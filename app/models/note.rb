# encoding: utf-8
# == Schema Information
#
# Table name: notes
#
#  id            :integer          not null, primary key
#  note          :text
#  noteable_type :string(255)
#  author_id     :integer
#  created_at    :datetime
#  updated_at    :datetime
#  project_id    :integer
#  attachment    :string(255)
#  line_code     :string(255)
#  commit_id     :string(255)
#  noteable_id   :integer
#  system        :boolean          default(FALSE), not null
#  st_diff       :text
#

require 'carrierwave/orm/activerecord'
require 'file_size_validator'

class Note < ActiveRecord::Base
  include Mentionable

  default_value_for :system, false

  attr_mentionable :note

  belongs_to :project
  belongs_to :noteable, polymorphic: true
  belongs_to :author, class_name: "User"

  delegate :name, to: :project, prefix: true
  delegate :name, :email, to: :author, prefix: true

  validates :note, :project, presence: true
  validates :line_code, format: { with: /\A[a-z0-9]+_\d+_\d+\Z/ }, allow_blank: true
  validates :attachment, file_size: { maximum: 10.megabytes.to_i }

  validates :noteable_id, presence: true, if: ->(n) { n.noteable_type.present? && n.noteable_type != 'Commit' }
  validates :commit_id, presence: true, if: ->(n) { n.noteable_type == 'Commit' }

  mount_uploader :attachment, AttachmentUploader

  # Scopes
  scope :for_commit_id, ->(commit_id) { where(noteable_type: "Commit", commit_id: commit_id) }
  scope :inline, ->{ where("line_code IS NOT NULL") }
  scope :not_inline, ->{ where(line_code: [nil, '']) }
  scope :system, ->{ where(system: true) }
  scope :common, ->{ where(noteable_type: ["", nil]) }
  scope :fresh, ->{ order(created_at: :asc, id: :asc) }
  scope :inc_author_project, ->{ includes(:project, :author) }
  scope :inc_author, ->{ includes(:author) }

  serialize :st_diff
  before_create :set_diff, if: ->(n) { n.line_code.present? }
  after_update :set_references

  class << self
    def create_status_change_note(noteable, project, author, status, source)
      body = "_#{source.gfm_reference + 'が' if source}#{i18n_status_change_action(status)}_"

      create(
        noteable: noteable,
        project: project,
        author: author,
        note: body,
        system: true
      )
    end

    # +noteable+ was referenced from +mentioner+, by including GFM in either
    # +mentioner+'s description or an associated Note.
    # Create a system Note associated with +noteable+ with a GFM back-reference
    # to +mentioner+.
    def create_cross_reference_note(noteable, mentioner, author, project)
      gfm_reference = mentioner_gfm_ref(noteable, mentioner, project)

      note_options = {
        project: project,
        author: author,
        note: cross_reference_note_content(gfm_reference),
        system: true
      }

      if noteable.kind_of?(Commit)
        note_options.merge!(noteable_type: 'Commit', commit_id: noteable.id)
      else
        note_options.merge!(noteable: noteable)
      end

      create(note_options) unless cross_reference_disallowed?(noteable, mentioner)
    end

    def create_milestone_change_note(noteable, project, author, milestone)
      body = if milestone.nil?
               '_マイルストーンが削除されました_'
             else
               "_マイルストーンが#{milestone.title}に変更されました_"
             end

      create(
        noteable: noteable,
        project: project,
        author: author,
        note: body,
        system: true
      )
    end

    def create_assignee_change_note(noteable, project, author, assignee)
      body = assignee.nil? ? '_担当者が削除されました_' : "_@#{assignee.username} に再度割り当てられました_"

      create({
        noteable: noteable,
        project: project,
        author: author,
        note: body,
        system: true
      })
    end

    def create_labels_change_note(noteable, project, author, added_labels, removed_labels)
      labels_count = added_labels.count + removed_labels.count
      added_labels = added_labels.map{ |label| "~#{label.id}" }.join(' ')
      removed_labels = removed_labels.map{ |label| "~#{label.id}" }.join(' ')
      message = 'ラベル'

      if added_labels.present?
        message << " #{added_labels} を追加し"
        if !removed_labels.present?
          message << 'ました'
        end
      end

      if removed_labels.present?
        message << " #{removed_labels} を削除しました"
      end

      body = "_#{message.capitalize}_"

      create(
        noteable: noteable,
        project: project,
        author: author,
        note: body,
        system: true
      )
    end

    def create_new_commits_note(merge_request, project, author, new_commits, existing_commits = [], oldrev = nil)
      total_count = new_commits.length + existing_commits.length
      body = "#{total_count }件のコミットを追加しました:\n\n"

      if existing_commits.length > 0
        commit_ids =
          if existing_commits.length == 1
            existing_commits.first.short_id
          else
            if oldrev
              "#{Commit.truncate_sha(oldrev)}...#{existing_commits.last.short_id}"
            else
              "#{existing_commits.first.short_id}..#{existing_commits.last.short_id}"
            end
          end

        commits_text = ActionController::Base.helpers.pluralize(existing_commits.length, 'commit')

        branch = 
          if merge_request.for_fork?
            "#{merge_request.target_project_namespace}:#{merge_request.target_branch}"
          else
            merge_request.target_branch
          end

        message = "* #{commit_ids} - _#{commits_text} from branch `#{branch}`_"
        body << message
        body << "\n"
      end

      new_commits.each do |commit|
        message = "* #{commit.short_id} - #{commit.title}"
        body << message
        body << "\n"
      end

      create(
        noteable: merge_request,
        project: project,
        author: author,
        note: body,
        system: true
      )
    end

    def discussions_from_notes(notes)
      discussion_ids = []
      discussions = []

      notes.each do |note|
        next if discussion_ids.include?(note.discussion_id)

        # don't group notes for the main target
        if !note.for_diff_line? && note.noteable_type == "MergeRequest"
          discussions << [note]
        else
          discussions << notes.select do |other_note|
            note.discussion_id == other_note.discussion_id
          end
          discussion_ids << note.discussion_id
        end
      end

      discussions
    end

    def build_discussion_id(type, id, line_code)
      [:discussion, type.try(:underscore), id, line_code].join("-").to_sym
    end

    # Determine if cross reference note should be created.
    # eg. mentioning a commit in MR comments which exists inside a MR
    # should not create "mentioned in" note.
    def cross_reference_disallowed?(noteable, mentioner)
      if mentioner.kind_of?(MergeRequest)
        mentioner.commits.map(&:id).include? noteable.id
      end
    end

    # Determine whether or not a cross-reference note already exists.
    def cross_reference_exists?(noteable, mentioner)
      gfm_reference = mentioner_gfm_ref(noteable, mentioner)
      notes = if noteable.is_a?(Commit)
                where(commit_id: noteable.id)
              else
                where(noteable_id: noteable.id)
              end

      notes.where('note like ?', cross_reference_note_content(gfm_reference)).
        system.any?
    end

    def search(query)
      where("note like :query", query: "%#{query}%")
    end

    def cross_reference_note_suffix
      'から参照しました_'
    end

    private

    def cross_reference_note_content(gfm_reference)
      "_#{gfm_reference}" + cross_reference_note_suffix
    end

    # Prepend the mentioner's namespaced project path to the GFM reference for
    # cross-project references.  For same-project references, return the
    # unmodified GFM reference.
    def mentioner_gfm_ref(noteable, mentioner, project = nil)
      if mentioner.is_a?(Commit)
        if project.nil?
          return mentioner.gfm_reference.sub('commit ', 'commit %')
        else
          mentioning_project = project
        end
      else
        mentioning_project = mentioner.project
      end

      noteable_project_id = noteable_project_id(noteable, mentioning_project)

      full_gfm_reference(mentioning_project, noteable_project_id, mentioner)
    end

    # Return the ID of the project that +noteable+ belongs to, or nil if
    # +noteable+ is a commit and is not part of the project that owns
    # +mentioner+.
    def noteable_project_id(noteable, mentioning_project)
      if noteable.is_a?(Commit)
        if mentioning_project.repository.commit(noteable.id)
          # The noteable commit belongs to the mentioner's project
          mentioning_project.id
        else
          nil
        end
      else
        noteable.project.id
      end
    end

    # Return the +mentioner+ GFM reference.  If the mentioner and noteable
    # projects are not the same, add the mentioning project's path to the
    # returned value.
    def full_gfm_reference(mentioning_project, noteable_project_id, mentioner)
      if mentioning_project.id == noteable_project_id
        mentioner.gfm_reference
      else
        if mentioner.is_a?(Commit)
          mentioner.gfm_reference.sub(
            /(コミット )/,
            "\\1#{mentioning_project.path_with_namespace}@"
          )
        else
          mentioner.gfm_reference.sub(
            /(課題 |マージリクエスト )/,
            "\\1#{mentioning_project.path_with_namespace}"
          )
        end
      end
    end

    def i18n_status_change_action(status)
      case status
      when "opened"
        "オープンしました"
      when "reopened"
        "再オープンしました"
      when "closed"
        "クローズしました"
      else
        status
      end
    end
  end

  def commit_author
    @commit_author ||=
      project.team.users.find_by(email: noteable.author_email) ||
      project.team.users.find_by(name: noteable.author_name)
  rescue
    nil
  end

  def cross_reference?
    note.end_with?(self.class.cross_reference_note_suffix)
  end

  def find_diff
    return nil unless noteable && noteable.diffs.present?

    @diff ||= noteable.diffs.find do |d|
      Digest::SHA1.hexdigest(d.new_path) == diff_file_index if d.new_path
    end
  end

  def hook_attrs
    attributes
  end

  def set_diff
    # First lets find notes with same diff
    # before iterating over all mr diffs
    diff = Note.where(noteable_id: self.noteable_id, noteable_type: self.noteable_type, line_code: self.line_code).last.try(:diff)
    diff ||= find_diff

    self.st_diff = diff.to_hash if diff
  end

  def diff
    @diff ||= Gitlab::Git::Diff.new(st_diff) if st_diff.respond_to?(:map)
  end

  # Check if such line of code exists in merge request diff
  # If exists - its active discussion
  # If not - its outdated diff
  def active?
    return true unless self.diff
    return false unless noteable

    noteable.diffs.each do |mr_diff|
      next unless mr_diff.new_path == self.diff.new_path

      lines = Gitlab::Diff::Parser.new.parse(mr_diff.diff.lines.to_a)

      lines.each do |line|
        if line.text == diff_line
          return true
        end
      end
    end

    false
  end

  def outdated?
    !active?
  end

  def diff_file_index
    line_code.split('_')[0] if line_code
  end

  def diff_file_name
    diff.new_path if diff
  end

  def file_path
    if diff.new_path.present?
      diff.new_path
    elsif diff.old_path.present?
      diff.old_path
    end
  end

  def diff_old_line
    line_code.split('_')[1].to_i if line_code
  end

  def diff_new_line
    line_code.split('_')[2].to_i if line_code
  end

  def generate_line_code(line)
    Gitlab::Diff::LineCode.generate(file_path, line.new_pos, line.old_pos)
  end

  def diff_line
    return @diff_line if @diff_line

    if diff
      diff_lines.each do |line|
        if generate_line_code(line) == self.line_code
          @diff_line = line.text
        end
      end
    end

    @diff_line
  end

  def diff_line_type
    return @diff_line_type if @diff_line_type

    if diff
      diff_lines.each do |line|
        if generate_line_code(line) == self.line_code
          @diff_line_type = line.type
        end
      end
    end

    @diff_line_type
  end

  def truncated_diff_lines
    max_number_of_lines = 16
    prev_match_line = nil
    prev_lines = []

    diff_lines.each do |line|
      if line.type == "match"
        prev_lines.clear
        prev_match_line = line
      else
        prev_lines << line
        
        break if generate_line_code(line) == self.line_code

        prev_lines.shift if prev_lines.length >= max_number_of_lines
      end
    end

    prev_lines
  end

  def diff_lines
    @diff_lines ||= Gitlab::Diff::Parser.new.parse(diff.diff.lines.to_a)
  end

  def discussion_id
    @discussion_id ||= Note.build_discussion_id(noteable_type, noteable_id || commit_id, line_code)
  end

  # Returns true if this is a downvote note,
  # otherwise false is returned
  def downvote?
    votable? && (note.start_with?('-1') ||
                 note.start_with?(':-1:') ||
                 note.start_with?(':thumbsdown:') ||
                 note.start_with?(':thumbs_down_sign:')
                )
  end

  def for_commit?
    noteable_type == "Commit"
  end

  def for_commit_diff_line?
    for_commit? && for_diff_line?
  end

  def for_diff_line?
    line_code.present?
  end

  def for_issue?
    noteable_type == "Issue"
  end

  def for_merge_request?
    noteable_type == "MergeRequest"
  end

  def for_merge_request_diff_line?
    for_merge_request? && for_diff_line?
  end

  def for_project_snippet?
    noteable_type == "Snippet"
  end

  # override to return commits, which are not active record
  def noteable
    if for_commit?
      project.repository.commit(commit_id)
    else
      super
    end
  # Temp fix to prevent app crash
  # if note commit id doesn't exist
  rescue
    nil
  end

  # Returns true if this is an upvote note,
  # otherwise false is returned
  def upvote?
    votable? && (note.start_with?('+1') ||
                 note.start_with?(':+1:') ||
                 note.start_with?(':thumbsup:') ||
                 note.start_with?(':thumbs_up_sign:')
                )
  end

  def superceded?(notes)
    return false unless vote?

    notes.each do |note|
      next if note == self

      if note.vote? &&
        self[:author_id] == note[:author_id] &&
        self[:created_at] <= note[:created_at]
        return true
      end
    end

    false
  end

  def vote?
    upvote? || downvote?
  end

  def votable?
    for_issue? || (for_merge_request? && !for_diff_line?)
  end

  # Mentionable override.
  def gfm_reference
    noteable.gfm_reference
  end

  # Mentionable override.
  def local_reference
    noteable
  end

  def noteable_type_name
    if noteable_type.present?
      noteable_type.downcase
    end
  end

  # FIXME: Hack for polymorphic associations with STI
  #        For more information visit http://api.rubyonrails.org/classes/ActiveRecord/Associations/ClassMethods.html#label-Polymorphic+Associations
  def noteable_type=(sType)
    super(sType.to_s.classify.constantize.base_class.to_s)
  end

  # Reset notes events cache
  #
  # Since we do cache @event we need to reset cache in special cases:
  # * when a note is updated
  # * when a note is removed
  # Events cache stored like  events/23-20130109142513.
  # The cache key includes updated_at timestamp.
  # Thus it will automatically generate a new fragment
  # when the event is updated because the key changes.
  def reset_events_cache
    Event.reset_event_cache_for(self)
  end

  def set_references
    notice_added_references(project, author)
  end

  def editable?
    !read_attribute(:system)
  end
end
