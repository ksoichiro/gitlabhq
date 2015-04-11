# encoding: utf-8
module Emails
  module Profile
    def new_user_email(user_id, password, token = nil)
      @user = User.find(user_id)
      @password = password
      @target_url = user_url(@user)
      @token = token
      mail(to: @user.email, subject: subject("あなたのアカウントが作成されました"))
    end

    def new_email_email(email_id)
      @email = Email.find(email_id)
      @user = @email.user
      mail(to: @user.email, subject: subject("メールアドレスがあなたのアカウントに追加されました"))
    end

    def new_ssh_key_email(key_id)
      @key = Key.find(key_id)
      @user = @key.user
      @target_url = user_url(@user)
      mail(to: @user.email, subject: subject("SSHキーがあなたのアカウントに追加されました"))
    end
  end
end
