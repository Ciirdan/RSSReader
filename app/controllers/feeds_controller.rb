class FeedsController < ApplicationController

  def index
    @feeds = Feed.all
  end

  def show
    @feed = Feed.find(params[:id])
  end

  def new
    @feed = Feed.new
  end

  def create
    @feed = Feed.new(permit_attributes)
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
    paras.require(:feed).permit(:url, :title)
  end
end
