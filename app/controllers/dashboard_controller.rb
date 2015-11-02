class DashboardController < ApplicationController
  before_action :load_feeds

  def index
    if user_signed_in?
      # Find posts read by the user
      @user_posts = UserPost.where(user_id: current_user.id, read: true).select(:post_id)
      # Find all post in feeds of the user
      @posts = Post.where(feed_id: @feeds.ids)
      # Remove the posts already read
      @posts = @posts.where.not(id: @user_posts).order(:published_at => :desc).page(params[:page])
    else
      @posts = Post.where(feed_id: @feeds.ids).order(:published_at => :desc).page(params[:page])
    end
  end
end
