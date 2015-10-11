class FeedsController < ApplicationController
  before_action :authenticate_user!, :except => [:index, :show]
  # For Index And Side Menu
  before_action :load_feeds
  before_action :find_feed, :only => [:show, :edit, :update, :destroy]

  def index
    @posts = Post.where(feed_id: @feeds.ids).order(:published_at => :desc).page(params[:page])
  end

  def show
    @posts = Post.where(feed_id: @feed.id).order(:published_at => :desc).page(params[:page])
  end

  def new
    @feed = Feed.new
  end

  def create
    #Look for feed with given url
    @feed = Feed.find_or_initialize_by(permit_attributes)

    if @feed.new_record?
      #Parse url
      if uri?(@feed.url)
        begin
          #Rescued if not a feed
          feed = Feedjira::Feed.fetch_and_parse(@feed.url)

          @feed.title = feed.title
          @feed.description = feed.description
          @feed.site_url = feed.url

          if @feed.save
            @feed.refresh
            current_user.feeds << @feed
            flash[:success] = 'Feed added'
          end
        #Rescue & Display error if feed invalid
        rescue Feedjira::FetchFailure
          flash[:error] = 'Invalid Feed'
        end
      end

    else
      if not current_user.feeds.include?(@feed)
        current_user.feeds << @feed
        flash[:success] = 'Feed added'
      else
        flash[:error] = 'Feed already added'
      end
    end

    redirect_to root_path
  end

  def edit
  end

  def update

  end

  def destroy

  end

  private

  def permit_attributes
    params.require(:feed).permit(:url)
  end

  private

  def find_feed
    @feed = Feed.find(params[:id])
  end

  def load_feeds
    if user_signed_in?
      @feeds = current_user.feeds
    else
      @feeds = Feed.all
    end
  end

  def uri?(string)
    uri = URI.parse(string)
    %w( http https ).include?(uri.scheme)
    rescue URI::BadURIError
      false
    rescue URI::InvalidURIError
      false
  end
end
