# encoding: utf-8
class Profiles::PasswordsController < Profiles::ApplicationController
  skip_before_action :check_password_expiration, only: [:new, :create]

  before_action :set_user
  before_action :authorize_change_password!

  layout :determine_layout

  def new
  end

  def create
    unless @user.password_automatically_set || @user.valid_password?(user_params[:current_password])
      redirect_to new_profile_password_path, alert: '現在のパスワードを正しく入力してください'
      return
    end

    new_password = user_params[:password]
    new_password_confirmation = user_params[:password_confirmation]

    result = @user.update_attributes(
      password: new_password,
      password_confirmation: new_password_confirmation,
      password_automatically_set: false
    )

    if result
      @user.update_attributes(password_expires_at: nil)
      redirect_to root_path, notice: 'パスワードは正常に変更されました'
    else
      render :new
    end
  end

  def edit
  end

  def update
    password_attributes = user_params.select do |key, value|
      %w(password password_confirmation).include?(key.to_s)
    end
    password_attributes[:password_automatically_set] = false

    unless @user.password_automatically_set || @user.valid_password?(user_params[:current_password])
      redirect_to edit_profile_password_path, alert: '現在のパスワードを正しく入力してください'
      return
    end

    if @user.update_attributes(password_attributes)
      flash[:notice] = "パスワードは正常に更新されました。新しいパスワードでログインしてください"
      redirect_to new_user_session_path
    else
      render 'edit'
    end
  end

  def reset
    current_user.send_reset_password_instructions
    redirect_to edit_profile_password_path, notice: 'パスワードのリセット方法についてのご案内をメールでお送りしました'
  end

  private

  def set_user
    @user = current_user
  end

  def determine_layout
    if [:new, :create].include?(action_name.to_sym)
      'application'
    else
      'profile'
    end
  end

  def authorize_change_password!
    return render_404 if @user.ldap_user?
  end

  def user_params
    params.require(:user).permit(:current_password, :password, :password_confirmation)
  end
end
