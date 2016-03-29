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

  def group_icon(group)
    if group.is_a?(String)
      group = Group.find_by(path: group)
    end

    if group && group.avatar.present?
      group.avatar.url
    else
      'no_group_avatar.png'
    end
  end

  def group_title(group, name = nil, url = nil)
    full_title = link_to(simple_sanitize(group.name), group_path(group))
    full_title += ' &middot; '.html_safe + link_to(simple_sanitize(name), url) if name

    content_tag :span do
      full_title
    end
  end
end
