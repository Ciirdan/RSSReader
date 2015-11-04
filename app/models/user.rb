class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :trackable, :validatable, :authentication_keys => [:login]

  attr_accessor :login

  has_many :user_feeds, :dependent => :destroy
  has_many :feeds, :through => :user_feeds

  has_many :user_posts, :dependent => :destroy


  validates :username, :presence => true, :uniqueness => {:case_sensitive => false}
  validate :validate_username

  def not_read_posts(feeds)
    # Find posts read by the user
    user_posts = UserPost.where(user_id: self.id, read: true).select(:post_id)
    # Find all post in feeds of the user & Remove the posts already read
    posts = Post.where(feed_id: feeds.ids)
    posts = posts.where.not(id: user_posts)

    return posts
  end

  def validate_username
    if User.where(email: username).exists?
      errors.add(:username, :invalid)
    end
  end

  # Allow login with username & email
  def self.find_for_database_authentication(warden_conditions)
    conditions = warden_conditions.dup
    if login = conditions.delete(:login)
      where(conditions.to_hash).where(["lower(username) = :value OR lower(email) = :value", { :value => login.downcase }]).first
    else
      conditions[:email].downcase! if conditions[:email]
      where(conditions.to_hash).first
    end
  end
end
