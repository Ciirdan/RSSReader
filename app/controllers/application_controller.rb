class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :configure_permitted_parameters, if: :devise_controller?

  before_action :init_info

  protected

  # Use Username or Email for login
  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up) { |u| u.permit(:username, :email, :password, :password_confirmation, :remember_me) }
    devise_parameter_sanitizer.permit(:sign_in) { |u| u.permit(:login, :username, :email, :password, :remember_me) }
    devise_parameter_sanitizer.permit(:account_update) { |u| u.permit(:username, :email, :password, :password_confirmation, :current_password) }
  end

  # For autocompletion
  def current_user
    super
  end

  def user_signed_in?
    super
  end

  def authenticate_user!
    super
  end

  def init_info
    @q = Post.ransack(params[:q])
    if user_signed_in?
      @feeds = current_user.feeds
    else
      @feeds = Feed.where(url: 'http://mercurenews.com/rss')
    end
  end

end
