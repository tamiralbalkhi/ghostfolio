require 'spec_helper'
require 'rails_helper'

RSpec.configure do |config|
  # Enable flags for running tests in random order
  config.order = :random

  # Include FactoryBot methods
  config.include FactoryBot::Syntax::Methods

  # Run tests in random order to surface order dependencies
  Kernel.srand config.seed
end

RSpec::Rails::FeatureHelper.configure do |config|
  # Add additional configuration here
end

# Additional RSpec configuration can be added below as needed.