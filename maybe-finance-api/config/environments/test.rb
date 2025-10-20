Rails.application.configure do
  # Settings specified here will take precedence over those in config/application.rb.

  # The test environment is used exclusively to run your application's test suite.
  # You never need to work with it otherwise. Remember that your test database is "scratch space" for the test suite and is wiped and recreated between test runs.
  
  # Code is not reloaded between test runs.
  config.cache_classes = true

  # Do not eager load code on boot. This avoids loading your application code when running tests.
  config.eager_load = false

  # Configure static file server for tests with Cache-Control for performance.
  config.public_file_server.enabled = true
  config.public_file_server.headers = {
    'Cache-Control' => 'public, max-age=3600'
  }

  # Show full error reports.
  config.consider_all_requests_local = true

  # Enable/disable caching. By default caching is disabled.
  # Run rails test test/controllers/your_controller_test.rb to see caching in action.
  config.action_controller.perform_caching = false

  # Raise exceptions instead of rendering exception templates.
  config.action_dispatch.show_exceptions = false

  # Disable request forgery protection in test environment.
  config.action_controller.allow_forgery_protection = false

  # Store uploaded files on the local file system in a temporary directory.
  config.active_storage.service = :test

  # Ensure that the mailer is set up for the test environment.
  config.action_mailer.delivery_method = :test

  # Print deprecation notices to the stderr.
  config.active_support.deprecation = :stderr

  # Raises error for missing translations
  # config.i18n.raise_on_missing_translations = true

  # Annotate rendered view with file names.
  # config.action_view.annotate_rendered_view_with_filenames = true
end