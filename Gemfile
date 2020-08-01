source 'https://rubygems.org'

ruby '2.7.1'

gem 'rails', '~> 6.0.3'
gem 'pg', '>= 0.18', '< 2.0'
gem 'puma', '~> 4.3'
gem 'sassc-rails'
gem 'uglifier', '>= 1.3.0'
gem 'rack-cors'
gem 'devise'
gem 'doorkeeper'
gem 'dotenv-rails'
gem 'active_model_serializers', '~> 0.10.10'
gem 'bootstrap', '~> 4.5.0'
gem 'jquery-rails'

group :development do
  gem 'listen', '>= 3.0.5', '< 3.3'
  gem 'bullet'
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
