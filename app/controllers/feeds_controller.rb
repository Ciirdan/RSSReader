class FeedsController < ApplicationController
  before_action :authenticate_user!, :except => [:index, :show]
  # For Index And Side Menu
  before_action :load_feeds
  before_action :find_feed, :only => [:show, :edit, :update, :destroy]

  def index
    if user_signed_in?
      @feed = Feed.new
    end
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

    # If feed doesn't exist
    if @feed.new_record?
      #Parse url
      if uri?(@feed.url)
        begin
          #Rescued if not a feed
          feed = Feedjira::Feed.fetch_and_parse(@feed.url)

          # Complete other field
          @feed.title = feed.title
          @feed.description = feed.description
          @feed.site_url = feed.url

          if @feed.save
            @feed.refresh
            current_user.feeds << @feed
            flash[:success] = 'Feed added'
          end
        # Rescue & Display error if feed invalid
        rescue Feedjira::FetchFailure
          flash[:error] = 'Invalid Feed'
          render :new
        end
      end

    # If feed exist
    else
      # Don't add a feed twice to a user
      if not @feeds.include?(@feed)
        current_user.feeds << @feed
        flash[:success] = 'Feed added'
      else
        flash[:error] = 'Feed already added'
      end
    end

    redirect_to root_path
  end

  # TODO: Create edit/update/destroy
  def edit

  end

  def update

  end

  def destroy
    user_feed = UserFeed.find_by(user_id: current_user.id, feed_id: @feed.id)

    unless user_feed.blank?
      user_feed.destroy
    end
  end

  def refresh
    @feeds.each do |feed|
      feed.refresh
    end

    redirect_to feeds_path
  end


  private

  def permit_attributes
    params.require(:feed).permit(:url)
  end

  private

  def find_feed
    @feed = Feed.find(params[:id])
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
