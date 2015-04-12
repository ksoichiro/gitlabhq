# encoding: utf-8
# == Schema Information
#
# Table name: services
#
#  id         :integer          not null, primary key
#  type       :string(255)
#  title      :string(255)
#  project_id :integer          not null
#  created_at :datetime
#  updated_at :datetime
#  active     :boolean          default(FALSE), not null
#  properties :text
#

class CampfireService < Service
  prop_accessor :token, :subdomain, :room
  validates :token, presence: true, if: :activated?

  def title
    'Campfire'
  end

  def description
    'シンプルなWebベースのリアルタイムグループチャット'
  end

  def to_param
    'campfire'
  end

  def fields
    [
      { type: 'text', name: 'token',     placeholder: '' },
      { type: 'text', name: 'subdomain', placeholder: '' },
      { type: 'text', name: 'room',      placeholder: '' }
    ]
  end

  def execute(push_data)
    room = gate.find_room_by_name(self.room)
    return true unless room

    message = build_message(push_data)

    room.speak(message)
  end

  private

  def gate
    @gate ||= Tinder::Campfire.new(subdomain, token: token)
  end

  def build_message(push)
    ref = push[:ref].gsub("refs/heads/", "")
    before = push[:before]
    after = push[:after]

    message = ""
    message << "[#{project.name_with_namespace}] "
    message << "#{push[:user_name]} "

    if before =~ /000000/
      message << "pushed new branch #{ref} \n"
    elsif after =~ /000000/
      message << "removed branch #{ref} \n"
    else
      message << "pushed #{push[:total_commits_count]} commits to #{ref}. "
      message << "#{project.web_url}/compare/#{before}...#{after}"
    end

    message
  end
end
