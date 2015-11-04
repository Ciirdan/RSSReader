class DashboardController < ApplicationController

  def index
    if user_signed_in?
      @posts = current_user.not_read_posts(@feeds).order(:published_at => :desc).page(params[:page])
    else
      @posts = Post.where(feed_id: @feeds.ids).order(:published_at => :desc).page(params[:page])
    end
  end
end
