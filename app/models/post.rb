class Post < ActiveRecord::Base
  belongs_to :feed

  has_many :user_posts

  def is_read?(current_user)
    post = self.user_posts.where(user_id: current_user.id).first
    unless post.blank?
      return post.read
    end
    false
  end

  def is_favorited?(current_user)
    post = self.user_posts.where(user_id: current_user.id).first
    unless post.blank?
      return post.favorited
    end
    false
  end

end
