class FeedsController < ApplicationController
  before_action :authenticate_user!, :except => [:show]
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
    add_feed params[:feed][:url]

    if flash[:error]
      render :new
    end

    redirect_to feeds_path
  end

  # TODO: Create edit/update
  def edit

  end

  def update

  end

  def destroy
    user_feed = UserFeed.find_by(user_id: current_user.id, feed_id: @feed.id)

    unless user_feed.blank?
      user_feed.destroy
    end

    redirect_to feeds_path
  end

  def refresh
    @feeds.each do |feed|
      feed.refresh
    end

    redirect_to root_path
  end

  # TODO file input
  def import

    file = File.open('data/leed-03-11-2015.opml')
    contents = file.read

    opml = OpmlSaw::Parser.new(contents)
    # Populate feeds
    opml.parse

    opml.feeds.each do |feed|
      add_feed feed[:xml_url]
    end

    redirect_to settings_path
  end

  private

  def permit_attributes
    params.require(:feed).permit(:url)
  end

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

  def add_feed(url)
    #Look for feed with given url
    @feed = Feed.find_or_initialize_by(:url => url)

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
          flash[:error] = "Invalid Feed #{@feed.url}"
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
  end
end
