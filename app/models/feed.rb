class Feed < ActiveRecord::Base
  after_create :touch_refreshed_at

  has_many :user_feeds, :dependent => :destroy
  has_many :users, :through => :user_feeds
  has_many :posts

  validates :url, :presence => true


  def refresh
    if DateTime.now.to_i - self.refreshed_at.to_i >= 1.minutes.to_i
      posts = Feedjira::Feed.fetch_and_parse(self.url).entries

      posts.each do |post|
        self.posts.find_or_create_by(
          title: post.title,
          content: post.summary,
          url: post.url,
          published_at: post.published
        )
      end
      touch_refreshed_at
    end
  end


  private

  def touch_refreshed_at
    self.touch :refreshed_at
    self.save
  end

end
