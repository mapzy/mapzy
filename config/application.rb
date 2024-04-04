# frozen_string_literal: true

require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Mapzy
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 7.1

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.

    config.autoload_lib(ignore: %w(assets tasks))
    
    config.time_zone = "Europe/Zurich"
    # config.eager_load_paths << Rails.root.join("extras")

    config.action_mailer.default_url_options = { host: "localhost" }

    config.action_mailer.delivery_method = :mailpace
    config.action_mailer.mailpace_settings = { api_token: ENV["MAILPACE_TOKEN"] }

    config.active_job.queue_adapter = :solid_queue

    # Use Rspec as test framework
    config.generators do |g|
      g.test_framework :rspec,
                       fixtures: false,
                       view_specs: false,
                       helper_specs: false,
                       routing_specs: false
    end
  end
end
