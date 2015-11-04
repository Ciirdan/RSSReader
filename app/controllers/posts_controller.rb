class PostsController < ApplicationController
  before_action :authenticate_user!
  before_action :find_post, :except => [:search, :read_all]


  def search
    @q = Post.ransack(params[:q])
    @posts = @q.result.page(params[:page])

    render 'feeds/show'
  end

  def read_all
    @posts = current_user.not_read_posts(@feeds)

    @posts.each do |post|
      user_post = UserPost.find_or_create_by(user_id: current_user.id, post_id: post.id)
      user_post.read = true

      user_post.save
    end

    redirect_to root_path
  end

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
