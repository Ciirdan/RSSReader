class Feed < ActiveRecord::Base
  has_many :users, :through => :user_feeds
  has_many :posts
end
