# encoding: utf-8
module GroupsHelper
  def remove_user_from_group_message(group, user)
    "本当に \"#{user.name}\" を \"#{group.name}\" から削除しますか？"
  end

  def leave_group_message(group)
    "本当にグループ \"#{group}\" を離脱しますか？"
  end

  def should_user_see_group_roles?(user, group)
    if user
      user.is_admin? || group.members.exists?(user_id: user.id)
    else
      false
    end
  end

  def group_head_title
    title = @group.name

    title = if current_action?(:issues)
              "課題 - " + title
            elsif current_action?(:merge_requests)
              "マージリクエスト - " + title
            elsif current_action?(:members)
              "メンバー - " + title
            elsif current_action?(:edit)
              "設定 - " + title
            else
              title
            end

    title
  end

  def group_settings_page?
    if current_controller?('groups')
      current_action?('edit') || current_action?('projects')
    else
      false
    end
  end
end
