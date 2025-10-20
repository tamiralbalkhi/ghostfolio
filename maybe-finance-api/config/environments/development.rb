Rails.application.configure do
  # Settings specified here will take precedence over those in config/application.rb.

  # Code is not reloaded between requests.
  config.cache_classes = true

  # Eager load code on boot. This is necessary for performance in production.
  config.eager_load = true

  # Show full error reports.
  config.consider_all_requests_local = false

  # Enable caching.
  config.action_controller.perform_caching = true

  # Store uploaded files on the local file system.
  config.active_storage.service = :local

  # Disable serving static files from the `/public` folder by default since
  # Apache or NGINX already handles this.
  config.public_file_server.enabled = false

  # Compress JavaScripts and CSS.
  config.assets.js_compressor = :uglifier
  config.assets.css_compressor = :sass

  # Do not fallback to assets pipeline if a precompiled asset is missed.
  config.assets.compile = false

  # Generate digests for assets URLs.
  config.assets.digest = true

  # Force all access to the app over SSL, use Secure Cookies, and set the
  # `X-Frame-Options` header to prevent clickjacking.
  config.force_ssl = true

  # Use the lowest log level to ensure availability of diagnostic information
  # when problems arise.
  config.log_level = :debug

  # Use a different logger for distributed setups.
  # config.logger = ActiveSupport::TaggedLogging.new(SyslogLogger.new)

  # Use a different cache store in production.
  # config.cache_store = :mem_cache_store

  # Enable serving of images, stylesheets, and JavaScripts from an asset server.
  # config.asset_host = 'http://assets.example.com'

  # Precompile additional assets.
  # application.js, application.css, and all non-JS/CSS in the app/assets folder are already added.
  # config.assets.precompile += %w( search.js )

  # Disable delivery errors, bad email addresses will be ignored.
  config.action_mailer.raise_delivery_errors = false

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