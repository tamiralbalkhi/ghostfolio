module MaybeFinanceApi
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 6.1

    # API-only application configuration
    config.api_only = true
    config.time_zone = 'UTC'
    config.active_record.default_timezone = :utc

    # Generator configuration
    config.generators do |g|
      g.test_framework :rspec
      g.factory_bot dir: 'spec/factories'
      g.serializer false
      g.helper false
      g.assets false
    end

    # ActiveRecord optimizations for API
    config.active_record.belongs_to_required_by_default = true

    # Eager load paths for services and lib
    config.eager_load_paths += %W(#{config.root}/app/services)
    config.eager_load_paths += %W(#{config.root}/lib)

    # CORS and middleware
    config.middleware.insert_before 0, Rack::Cors

    # Session configuration for API
    config.session_store :disabled
  end
end
