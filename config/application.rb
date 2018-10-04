require File.expand_path('../boot', __FILE__)

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(:default, Rails.env)

module Yonodesperdicio
  class Application < Rails::Application
    config.time_zone = 'UTC'
    config.i18n.default_locale = :es
    config.i18n.enforce_available_locales = true
    I18n.config.enforce_available_locales = true
    ActionMailer::Base.layout "mail"

    # Do not swallow errors in after_commit/after_rollback callbacks.
    config.active_record.raise_in_transactional_callbacks = true

    config.active_job.queue_adapter = :sidekiq

    # No usar TLS para conectar al SMTP ya
    # que no tenemos un certificado válido
    config.action_mailer.smtp_settings = {
      enable_starttls_auto: false
    }

    config.app_generators.scaffold_controller = :scaffold_controller
  end
end

