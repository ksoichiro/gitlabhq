class IssuableBaseService < BaseService
  private

  def create_assignee_note(issuable)
    SystemNoteService.change_assignee(
      issuable, issuable.project, current_user, issuable.assignee)
  end

  def create_milestone_note(issuable)
    SystemNoteService.change_milestone(
      issuable, issuable.project, current_user, issuable.milestone)
  end

  def create_labels_note(issuable, added_labels, removed_labels)
    SystemNoteService.change_label(
      issuable, issuable.project, current_user, added_labels, removed_labels)
  end
end
