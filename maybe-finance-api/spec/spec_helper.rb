RSpec.configure do |config|
  # Enable the use of color in the output
  config.color = true

  # Use the documentation formatter for detailed output
  config.formatter = :documentation

  # Configure the default behavior of RSpec
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  # Enable random order for test execution
  config.order = :random

  # Seed random number generator for reproducible test order
  Kernel.srand config.seed
end