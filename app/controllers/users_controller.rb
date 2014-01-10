# encoding: utf-8
class UsersController < ApplicationController

  before_action :signed_in_user, only: [:index, :edit, :update, :destroy, :following, :followers]
  before_action :correct_user, only: [:edit, :update]
  before_action :admin_user, only: :destroy
  
  def index
    @users = User.paginate(page: params[:page])
  end

  def show
  	@user = User.find(params[:id])
    # @microposts = @user.microposts.paginate(page: params[:page])
    # 用一个类方法，将所附属的回复也调用出来了。
    # 没派上用场，实际上，根据用户 ID 本身就可以调出所有的微博，包括回复，所以
    # 以上这一条是多此一举，仅为知道如何用这个。
    @microposts = @user.microposts_all.paginate(page: params[:page])
  end
  
  def new
  	@user = User.new
  end

  def create
  	@user = User.new(user_params)
  	if @user.save
  		sign_in @user
      flash[:success] = "welcome all of you"
  		redirect_to @user
  	else
  		render 'new'
  	end
  end

  def edit
    # @user = User.find(params[:id])
  end

  def update
    # @user = User.find(params[:id])
    if @user.update_attributes(user_params)
      flash[:success] = "更新成功"
      redirect_to @user
    else
      render 'edit'
    end
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "用户被删除了"
    redirect_to users_url
  end

  def following
    @title = "关注"
    @user = User.find(params[:id])
    @users = @user.followed_users.paginate(page: params[:page])
    render 'show_follow'
  end

  def followers
    @title = "粉丝"
    @user = User.find(params[:id])
    @users = @user.followers.paginate(page: params[:page])
    render 'show_follow'
  end

  private

    def user_params
  	 params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end

    # before filters

    # def signed_in_user
    #  store_location
    #  redirect_to signin_url, notice: "请登陆" unless signed_in?
    # end

    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_path) unless current_user?(@user)
    end

    def admin_user
      redirect_to(root_path) unless current_user.admin?
    end
  
end
