class GroupsController < ApplicationController
  before_action :set_edit_group, only: ["update"]

  def index
    @groups = Group.all
    @group = Group.new
    @book = Book.new
  end

  def show
    @group = Group.find(params[:id])
    @user = User.all
    @book = Book.new
  end

  def new
    @group = Group.new
  end

  def create
    @group = Group.new(group_params)
    @group.users << current_user
    @group.owner_id = current_user.id
    if @group.save
      redirect_to groups_path
    else
      render :new
    end
  end

  def edit
    @group = Group.find(params[:id])
  end

  def update
    @group = Group.find(params[:id])
    if @group.update(group_params)
      redirect_to groups_path
    else
      render :edit
    end
  end

  def add_user
    @group = Group.find(params[:id])
    @group.users << current_user
    redirect_to group_path
  end

  def destroy_user
    @group = Group.find(params[:id])
    @user = current_user
    @groupuser = GroupUser.find_by(user_id: @user.id, group_id: @group.id)
    @groupuser.destroy
    redirect_to group_path
  end

  def new_mail
    @group = Group.find(params[:id])
  end

  def send_mail
    @group = Group.find(params[:id])
    group_users = @group.users
    @mail_title = params[:mail_title]
    @mail_content = params[:mail_content]
    ContactMailer.send_mail(@mail_title, @mail_content,group_users).deliver
  end

  private

  def set_edit_group
    @group = Group.find(params[:id])
    unless @group.owner_id == current_user.id
      redirect_to groups_path
    end
  end

  def group_params
    params.require(:group).permit(:name, :introduction, :image)
  end

end
