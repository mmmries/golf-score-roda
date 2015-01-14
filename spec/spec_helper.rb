ENV["RACK_ENV"] = "test"
require_relative "../golfscore"
require 'rack/test'
require 'pry'

RSpec.configure do |config|
  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.order = :random

  Kernel.srand config.seed
end
