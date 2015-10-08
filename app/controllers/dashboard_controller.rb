class DashboardController < ApplicationController

  def index
    @posts = Feed
  end
end
