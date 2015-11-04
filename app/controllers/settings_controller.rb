class SettingsController < ApplicationController
  before_action :authenticate_user!

  # Self feeds/add feeds
  def show
    @user = current_user
  end

  def update
    @user = current_user
    if @user.update_attributes(permit_params)
      flash[:success] = 'User updated'
      sign_in @user, :bypass => true
    end

    redirect_to settings_path
  end


  private

  def permit_params
    params.require(:user).permit(:per_page, :email, :password, :password_confirmation)
  end
end
