# encoding: utf-8

class UsersGroupsController < ApplicationController
  before_filter :group

  # Authorize
  before_filter :authorize_admin_group!

  layout 'group'

  def create
    @group.add_users(params[:user_ids].split(','), params[:group_access])

    redirect_to members_group_path(@group), notice: 'ユーザは正常に追加されました。'
  end

  def update
    @member = @group.users_groups.find(params[:id])
    @member.update_attributes(member_params)
  end

  def destroy
    @users_group = @group.users_groups.find(params[:id])
    if can?(current_user, :destroy, @users_group)  # May fail if last owner.
      @users_group.destroy
      respond_to do |format|
        format.html { redirect_to members_group_path(@group), notice: 'ユーザはグループから正常に削除されました。' }
        format.js { render nothing: true }
      end
    else
      return render_403
    end
  end

  protected

  def group
    @group ||= Group.find_by(path: params[:group_id])
  end

  def authorize_admin_group!
    unless can?(current_user, :manage_group, group)
      return render_404
    end
  end

  def member_params
    params.require(:users_group).permit(:group_access, :user_id)
  end
end
