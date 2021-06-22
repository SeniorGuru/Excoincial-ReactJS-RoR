# encoding: UTF-8
# frozen_string_literal: true

require File.expand_path('../shared', __FILE__)

Rails.application.configure do
  # Settings specified here will take precedence over those in config/application.rb.

  # In the development environment your application's code is reloaded on
  # every request. This slows down response time but is perfect for development
  # since you don't have to restart the web server when you make code changes.
  config.cache_classes = false

  # Do not eager load code on boot.
  config.eager_load = false

  # Show full error reports and disable caching.
  config.consider_all_requests_local       = true
  config.action_controller.perform_caching = false

  # Don't care if the mailer can't send.
  config.action_mailer.raise_delivery_errors = false

  #config.action_mailer.perform_caching = false

  config.action_mailer.delivery_method     = :smtp

  # SMTP_ADDRESS - address, where fake rekay is running. By default it is equal localhost.
  # SMTP_PORT - port, where fake relay is running. By default it is equal to 1025.
  #
  # Notice: Used by WorkBench.
  # config.action_mailer.smtp_settings = {
  #     address: ENV.fetch('SMTP_ADDRESS', 'localhost'),
  #     port: ENV.fetch('SMTP_PORT', 1025)
  # }
  #
  # options = { host: ENV.fetch('SMTP_URL_ADDRESS', 'localhost') }
  # options[:port] = 3000 if options[:host] == 'localhost'
  #
  # config.action_mailer.default_url_options = options

  config.action_mailer.default_url_options = {
      host: ENV['AUTH_URL_HOST'],
      protocol: ENV['URL_SCHEME']
  }

  config.action_mailer.smtp_settings = {
      address:              ENV['SMTP_ADDRESS'],
      port:                 ENV['SMTP_PORT'],
      domain:               ENV['SMTP_DOMAIN'],
      user_name:            ENV['SMTP_EMAIL_ADDRESS'],
      password:             ENV['SMTP_EMAIL_PASSWORD'],
      authentication:       :plain,
      enable_starttls_auto: true
  }

  config.action_mailer.default_options = { from: 'excoincial-noreply <support@excoincial.com>' }

  # Raise an error on page load if there are pending migrations.
  config.active_record.migration_error = :page_load

  # Debug mode disables concatenation and preprocessing of assets.
  # This option may cause significant delays in view rendering with a large
  # number of complex assets.
  config.assets.debug = false

  config.active_record.default_timezone = :utc

  # Asset digests allow you to set far-future HTTP expiration dates on all assets,
  # yet still be able to expire them through the digest params.
  config.assets.digest = true

  # Adds additional error checking when serving assets at runtime.
  # Checks for improperly declared sprockets dependencies.
  # Raises helpful error messages.
  config.assets.raise_runtime_errors = true

  # Raises error for missing translations
  # config.action_view.raise_on_missing_translations = true
  # Bullet gem config.
  config.after_initialize do
    Bullet.enable = true if ENV['BULLET'] == 'true'
    Bullet.bullet_logger = true
    Bullet.add_footer = true
  end
end
