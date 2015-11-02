class SettingsController < ApplicationController
  before_action :authenticate_user!
  before_action :load_feeds

  # Self feeds/add feeds
  def show

  end

end
