source 'https://rubygems.org'

ruby '3.1.2'

gem 'rails', '~> 7.0.4'
gem 'pg', '>= 0.18', '< 2.0'
gem 'puma', '~> 5.6'
gem 'sassc-rails'
gem 'uglifier', '>= 1.3.0'
gem 'rack-cors'
gem 'devise'
gem 'doorkeeper'
gem 'dotenv-rails'
gem 'bootstrap', '~> 4.6.0', '< 5'
gem 'jquery-rails'
gem 'nokogiri', '>= 1.11.0.rc4'

group :development do
  gem 'listen', '>= 3.0.5', '< 3.8'
end

group :development, :test do
  gem 'pry-rails'
  gem 'rspec-rails'
  gem 'coderay'
  gem 'rubocop'
end

group :test do
  gem 'factory_bot_rails'
  gem 'rspec_junit_formatter'
end

group :production do
  gem 'rack-attack'
end
