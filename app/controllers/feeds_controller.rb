class FeedsController < ApplicationController
  before_action :authenticate_user!, :only => [:new, :create, :edit, :update, :destroy]

  def index
    if user_signed_in?
      @feeds = current_user.feeds
    else
      @feeds = Feed.all
    end
  end

  def show
    @feed = Feed.find(params[:id])
  end

  def new
    @feed = Feed.new
  end

  def create
    @feed = Feed.find_or_initialize_by(permit_attributes)

    if @feed.new_record?
      begin
        feed = Feedjira::Feed.fetch_and_parse(@feed.url)
      else
        @feed.title = feed.title
        @feed.description = feed.description
        @feed.site_url = feed.url

        if @feed.save
          @feed.refresh
          current_user.feeds << @feed
        end
      end
    else
      current_user.feeds << @feed
    end
    redirect_to feeds_path
  end

  def edit
    @feed = Feed.find(params[:id])
  end

  def update

  end

  def destroy

  end

  private

  def permit_attributes
    params.require(:feed).permit(:url)
  end

end
