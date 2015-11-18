source 'https://rubygems.org'

# Rails
gem 'rails', '4.2.3'
group :production do
  gem 'puma'
end
group :development, :test do
  gem 'thin'
end

# Application
gem 'devise'
gem 'kaminari'
gem 'feedjira'
gem 'whenever'
gem 'opml_saw', :git => "git://github.com/feedbin/opml_saw.git", :branch => "master"
gem 'ransack'

# DB
gem 'pg'
group :development, :test do
  gem 'sqlite3'
end

# JS & CSS
gem 'sass-rails'
gem 'uglifier', '>= 1.3.0'
gem 'jquery-rails'
gem 'bootstrap-sass'
gem 'font-awesome-sass'

# Views
gem 'haml'
gem 'haml-rails'
gem 'simple_form'

group :development, :test do
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'quiet_assets'
end

group :test do
  gem 'rspec-rails'
  gem 'factory_girl_rails'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
