class UsersController < ApplicationController
  before_action :set_user, only: [:show, :destroy]
  before_action :logged_in_user, only: [:edit, :update, :index, :destroy]
  before_action :correct_user,   only: [:edit, :update]
  # any sufficiently sophisticated attacker could simply issue a DELETE
  # request directly from the command line to delete any user on the site
  before_action :admin_user,     only: :destroy

  DEFAULT_PER_PAGE = 10
  # GET /users
  # GET /users.json
  def index
    @users = User.paginate(page: params[:page], :per_page => DEFAULT_PER_PAGE)
  end

  # GET /users/1
  # GET /users/1.json
  def show
    @microposts = @user.microposts.paginate(page: params[:page], :per_page => DEFAULT_PER_PAGE)
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  # after the action finishes, it automatically renders the view?
  def edit
    @user = User.find(params[:id])
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(user_params)
    if @user.save
      @user.send_activation_email
      flash[:info] = "Please check your email to activate your account."
      redirect_to root_url
      # Although our authentication system is now working, newly registered users might be confused, as they are not
      # logged in by default. Because it would be strange to force users to log in immediately after signing up, we’ll
      # log in new users automatically as part of the signup process.
      # log_in(@user)
      # The Rails way to display a temporary message is to use a special method called the flash, which we can treat
      # like a hash. Rails adopts the convention of a :success key for a message indicating a successful result
      # flash[:success] = "Welcome to the Sample App!"

      # Rails automatically infers from redirect_to @user that we want to redirect to user_url(@user)
      # redirect_to @user
    else
      render 'new'
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    @user = User.find(params[:id])
    if @user.update_attributes(user_params)
      # Handle a successful update.
      redirect_back_or @user
    else
      render 'edit'
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user.destroy

    flash[:success] = 'User was successfully destroyed.'
    redirect_to users_url
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_user
    @user = User.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end

  # Confirms the correct user.
  def correct_user
    #
    @user = User.find(params[:id])
    redirect_to(root_url) if @user != current_user
  end

  # Confirms an admin user.
  def admin_user
    redirect_to(root_url) unless current_user.admin?
  end
end
