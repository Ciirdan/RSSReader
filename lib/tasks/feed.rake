namespace :feed do
  task refresh: :environment do
    @feeds = Feed.all

    @feeds.each do |feed|
      feed.refresh
    end
  end
end