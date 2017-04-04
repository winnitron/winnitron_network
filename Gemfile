source 'https://rubygems.org'
ruby '2.3.0'

gem 'rails', '4.2.6'
gem 'pg',    '~> 0.15'
gem 'puma',  '~> 3.4.0'


gem 'sass-rails', '~> 5.0.6'
gem 'uglifier',   '>= 1.3.0'
# See https://github.com/rails/execjs#readme for more supported runtimes
gem 'therubyracer', platforms: :ruby

gem 'jquery-rails'
gem 'jquery-ui-rails'
gem 'bootstrap-sass', '~> 3.3.6'

# Referencing my fork until my PR with a bugfix gets merged.
gem 'nested_form_fields', git: "https://github.com/aaronklaassen/nested_form_fields.git", ref: "5ebe908534971fbd4af0cf6f633aed8fedbf0b5a"
gem 'nokogiri', '1.6.8'
gem 'redis-rails', '~> 4'

gem 'jbuilder', '~> 2.0'
gem 'sdoc',     '~> 0.4.0', group: :doc

gem 'devise',  '~> 4.2.0'
gem 'omniauth'
gem 'omniauth-twitter'
#gem 'omniauth-github'
#gem 'omniauth-facebook'

gem 'rails_12factor'
gem 'figaro'
gem 'aws-sdk', '~> 2.3.14'
gem 'quiet_assets'

gem 'acts-as-taggable-on', '~> 3.4'
gem 's3_direct_upload', '~> 0.1.7'
gem 'postmark-rails'
gem 'gravtastic'
gem 'bootstrap-tagsinput-rails'
gem 'rubyzip'

gem 'newrelic_rpm'

group :development, :test do
  gem 'pry-rails'
end

group :development do
  gem 'web-console', '~> 2.0'
  gem 'better_errors'
  gem 'spring'
end

group :test do
  gem 'rspec-rails', '~> 3.4.2'
  gem 'factory_girl_rails', '~> 4.7.0'
  gem 'faker'
  gem 'simplecov', require: false
end
