# encoding: utf-8
module Emails
  module Profile
    def new_user_email(user_id, token = nil)
      @current_user = @user = User.find(user_id)
      @target_url = user_url(@user)
      @token = token
      mail(to: @user.notification_email, subject: subject("あなたのアカウントが作成されました"))
    end

    def new_email_email(email_id)
      @email = Email.find(email_id)
      @current_user = @user = @email.user
      mail(to: @user.notification_email, subject: subject("メールアドレスがあなたのアカウントに追加されました"))
    end

    def new_ssh_key_email(key_id)
      @key = Key.find(key_id)
      @current_user = @user = @key.user
      @target_url = user_url(@user)
      mail(to: @user.notification_email, subject: subject("SSHキーがあなたのアカウントに追加されました"))
    end
  end
end
