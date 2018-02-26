ENV['RAILS_ENV'] ||= 'test'
require 'simplecov'
SimpleCov.start

require File.expand_path('../../config/environment', __FILE__)

abort("The Rails environment is running in production mode!") if Rails.env.production?
require 'spec_helper'
require 'rspec/rails'
require 'devise'

Dir[Rails.root.join("spec/support/**/*.rb")].each { |f| require f }

ActiveRecord::Migration.maintain_test_schema!

RSpec.configure do |config|
  config.use_transactional_fixtures = true
  config.infer_spec_type_from_file_location!
  config.filter_rails_from_backtrace!

  config.include Devise::Test::ControllerHelpers, type: :controller
  config.include Warden::Test::Helpers, type: :feature
  config.include ActiveJob::TestHelper, type: :job
end

Geocoder.configure(lookup: :test)
Geocoder::Lookup::Test.add_stub(
  "New York, NY", [
    {
      'coordinates'  => [40.7143528, -74.0059731],
      'address'      => 'New York, NY, USA',
      'state'        => 'New York',
      'state_code'   => 'NY',
      'country'      => 'United States',
      'country_code' => 'US'
    }
  ]
)
