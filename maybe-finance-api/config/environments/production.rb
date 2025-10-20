Rails.application.configure do
  # Settings specified here will take precedence over those in config/application.rb.

  # Code is not reloaded between requests.
  config.cache_classes = true

  # Eager load code on boot. This eager loads most of your application in memory, 
  # allowing for faster boot times and reduced memory usage.
  config.eager_load = true

  # Full error reports are disabled and caching is turned on.
  config.consider_all_requests_local       = false
  config.action_controller.perform_caching = true

  # Ensure that the mailer is set up for production.
  config.action_mailer.raise_delivery_errors = false
  config.action_mailer.delivery_method = :smtp

  # Use a different cache store in production.
  config.cache_store = :memory_store

  # Enable serving static files from the `/public` folder by default.
  config.public_file_server.enabled = ENV['RAILS_SERVE_STATIC_FILES'].present?

  # Compress JavaScripts and CSS.
  config.assets.js_compressor = :uglifier
  config.assets.css_compressor = :sass

  # Do not fallback to assets pipeline if a precompiled asset is missed.
  config.assets.compile = false

  # Generate digests for assets URLs.
  config.assets.digest = true

  # Force all access to the app over SSL, use Secure Cookies, and set the default 
  # host for URL generation.
  config.force_ssl = true

  # Use the lowest log level to ensure availability of diagnostic information 
  # when problems arise.
  config.log_level = :info

  # Use a different logger for distributed setups.
  config.logger = ActiveSupport::TaggedLogging.new(Logger.new(STDOUT))

  # Use a different cache store in production.
  config.cache_store = :memory_store

  # Enable serving static files from the `/public` folder by default.
  config.public_file_server.enabled = true

  # Configure the default URL options for the mailer.
  config.action_mailer.default_url_options = { host: 'your-production-domain.com' }

  # Enable locale fallbacks for I18n (makes lookups for any locale fall back to 
  # the I18n.default_locale when a translation cannot be found).
  config.i18n.fallbacks = true

  # Send deprecation notices to registered listeners.
  config.active_support.deprecation = :notify

  # Use default logging formatter so that PID and timestamp are not suppressed.
  config.log_formatter = ::Logger::Formatter.new

  # Do not dump schema after migrations.
  config.active_record.dump_schema_after_migration = false
end