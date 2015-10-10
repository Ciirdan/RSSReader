namespace :feed do
  task refresh: :environment do
    @feeds = Feed.all

    @feeds.each do |feed|
      feed
    end
  end
end