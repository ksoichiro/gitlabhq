# encoding: utf-8

module Emails
  module Groups
    def group_access_granted_email(group_member_id)
      @group_member = GroupMember.find(group_member_id)
      @group = @group_member.group
      @target_url = group_url(@group)
      mail(to: @group_member.user.email,
           subject: subject("グループへのアクセス権が付与されました"))
    end
  end
end
