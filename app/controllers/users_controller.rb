class UsersController < ApplicationController


  before_action :set_user, only: [:show, :edit, :update, :destroy]
  before_action :require_same_user, only: [:edit, :show, :destroy]
  before_action :require_admin, only: [:destroy]
  def index

    @users = User.all

  end

  def new

    @user = User.new


  end

  def create

    @user = User.new(user_params)
    @user.admin = false
    if @user.save
      session[:user_id] = @user.id
      flash[:success] = "Welcome to the alpha-blog #{@user.username}"
      redirect_to user_path(@user)


    else

      render 'new'


    end

  end


  def edit


  end

  def update

    if @user.update(user_params)
      flash[:success] = "Successfully Updated."
      redirect_to articles_path
    else

      render 'edit'

    end


  end


  def show


  end

  def destroy

    @user.destroy
    flash[:danger] = "User and all articles of this user are deleted."
    redirect_to users_path

  end


  private
  def user_params

    params.require(:user).permit(:username, :email, :password)



  end

  def set_user
    @user = User.find(params[:id])

  end
  def require_same_user
    if (current_user != @user  && (current_user.admin? == false))
      flash[:danger] = "You can only edit your own account!"
      redirect_to root_path
    end
  end
  def require_admin

    if logged_in? && !current_user.admin?

      flash[:notice] = "You don't have permission to delete user!!"
      redirect_to root_path

    end


  end

end