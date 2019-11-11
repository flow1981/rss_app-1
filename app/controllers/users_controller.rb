class UsersController < ApplicationController
  def new
  end

  def signup # this is our 'CREATE'
    # let's add a check here to see if username is already taken
    @user = User.create(user_params)
    unless @user.save
      flash[:errors] = "Please enter valid information for signup. Account not created."
      return redirect_to signup_path 
    end
    session[:user_id] = @user.id
    session[:username] = @user.username
    redirect_to dashboard_url(username: @user.username)
  end

  def dashboard
    set_user
    @feed = Feed.new # this is to allow for a form_for @feed in dashboard
  end

  # def new_folder
  #   byebug
  #   Folder.create(folder_params)
  #   redirect_to dashboard_path
  # end

  def new_folder_or_feed
    byebug
    folder = Folder.find_or_create_by(name: params[:folder][:name], user_id: session[:user_id])
    feed = Feed.create_from_url({"link" => params[:feed][:link], "folder_id" => folder.id})
    #Feed.create_from_url(feed_params)
    redirect_to dashboard_path
  end

  def folder_view
    @folder = current_user.folders.find_by(name: params[:folder])
    #byebug
  end

  def feed_view
    # @folder = params[:folder]
    # @feed = params[:feed]
  end

  private
  
  def set_user
    @user = User.find(session[:user_id])
  end

  def user_params
    params.require(:user).permit(:username, :email, :password, :password_confirmation)
  end

  def folder_params
    params.require(:folder).permit(:name, :user_id)
  end

  def feed_params
    params.require(:feed).permit(:link, :folder_id)
  end

end