# encoding: utf-8
class Admin::GroupsController < Admin::ApplicationController
  before_action :group, only: [:edit, :show, :update, :destroy, :project_update, :members_update]

  def index
    @groups = Group.all
    @groups = @groups.sort(@sort = params[:sort])
    @groups = @groups.search(params[:name]) if params[:name].present?
    @groups = @groups.page(params[:page]).per(PER_PAGE)
  end

  def show
    @members = @group.members.order("access_level DESC").page(params[:members_page]).per(PER_PAGE)
    @projects = @group.projects.page(params[:projects_page]).per(PER_PAGE)
  end

  def new
    @group = Group.new
  end

  def edit
  end

  def create
    @group = Group.new(group_params)
    @group.name = @group.path.dup unless @group.name

    if @group.save
      @group.add_owner(current_user)
      redirect_to [:admin, @group], notice: 'グループが作成されました'
    else
      render "new"
    end
  end

  def update
    if @group.update_attributes(group_params)
      redirect_to [:admin, @group], notice: 'グループが更新されました'
    else
      render "edit"
    end
  end

  def members_update
    @group.add_users(params[:user_ids].split(','), params[:access_level], current_user)

    redirect_to [:admin, @group], notice: 'ユーザが追加されました'
  end

  def destroy
    @group.destroy

    redirect_to admin_groups_path, notice: 'グループが削除されました'
  end

  private

  def group
    @group = Group.find_by(path: params[:id])
  end

  def group_params
    params.require(:group).permit(:name, :description, :path, :avatar)
  end
end
