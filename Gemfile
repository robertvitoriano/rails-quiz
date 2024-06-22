source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "3.3.1"

# Bundle edge Rails instead: gem "rails", github: "rails/rails", branch: "main"
gem "rails", "~> 7.1.3.2"

# Use the Puma web server [https://github.com/puma/puma]
gem "puma", "~> 6.0"

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem "tzinfo-data", platforms: %i[ mingw mswin x64_mingw jruby ]

# Reduces boot times through caching; required in config/boot.rb
gem "bootsnap", require: false
gem "mysql2"
gem "byebug"
gem "bcrypt", "~> 3.1.7"
gem 'aws-sdk-s3', '~> 1'
gem 'rack-cors'
gem "jwt", "~> 2.2"
gem "dotenv-rails"
gem "rack"
gem 'simple_command'
gem 'actioncable'
gem 'omniauth-google-oauth2'
gem 'httparty'

group :development, :test do
  # See https://guides.rubyonrails.org/debugging_rails_applications.html#debugging-with-the-debug-gem
  gem "debug", platforms: %i[ mri mingw x64_mingw ]
end

group :development do
  gem 'faker'
end

