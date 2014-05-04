# encoding: utf-8

module Emails
  module Groups
    def group_access_granted_email(user_group_id)
      @membership = UsersGroup.find(user_group_id)
      @group = @membership.group
      @target_url = group_url(@group)
      mail(to: @membership.user.email,
           subject: subject("グループへのアクセス権が付与されました"))
    end
  end
end
