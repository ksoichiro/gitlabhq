# encoding: utf-8
module GroupsHelper
  def remove_user_from_group_message(group, member)
    if member.user
      "本当に \"#{member.user.name}\" を \"#{group.name}\" から削除しますか？"
    else
      "本当に \"#{member.invite_email}\" への \"#{group.name}\" への招待を取り消しますか？"
    end
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

  def group_icon(group)
    if group.is_a?(String)
      group = Group.find_by(path: group)
    end

    if group && group.avatar.present?
      group.avatar.url
    else
      image_path('no_group_avatar.png')
    end
  end
end
