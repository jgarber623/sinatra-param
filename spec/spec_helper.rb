require 'simplecov'

ENV['RACK_ENV'] = 'test'
ENV['SINATRA_ACTIVESUPPORT_WARNING'] = 'false'

Bundler.require(:default, :test)

require 'sinatra/json'
require 'sinatra/test_helpers'

RSpec.configure do |config|
  config.include Sinatra::TestHelpers

  config.disable_monkey_patching!
end
