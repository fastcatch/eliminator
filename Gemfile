source 'https://rubygems.org'
ruby "1.9.3"

gem 'rails', '~> 3.2.13'

gem 'sqlite3', group: [:development, :test]
group :production do
  gem 'pg'
  gem 'thin'
end

group :assets do
  gem 'sass-rails',   '~> 3.2'
  gem 'coffee-rails', '~> 3.2.1'
  gem 'bootstrap-sass', '~> 2.3.1.0'

  # See https://github.com/sstephenson/execjs#readme for more supported runtimes
  # gem 'therubyracer', :platforms => :ruby

  gem 'uglifier', '>= 1.0.3'
end

gem 'jquery-rails'
gem 'simple_form'
gem 'devise'

gem 'awesome_nested_set'
gem 'capistrano'

group :development do
  gem 'quiet_assets'
  gem 'ruby-debug19', :require => 'ruby-debug'
end