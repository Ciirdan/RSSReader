class PostsController < ApplicationController
  before_action :authenticate_user!
  before_action :find_post

  def favorite
    @user_post = UserPost.find_or_initialize_by(user_id: current_user.id, post_id: @post.id)
    @user_post.favorited = !@user_post.favorited
    @user_post.save
  end

  def read
    @user_post = UserPost.find_or_initialize_by(user_id: current_user.id, post_id: @post.id)
    @user_post.read = !@user_post.read
    @user_post.save
  end

  private

  def find_post
    @post = Post.find(params[:post_id])
  end
end
