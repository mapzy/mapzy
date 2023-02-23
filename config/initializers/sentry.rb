if Rails.env.production? && ENV.has_key?("SENTRY_DNS")
  Sentry.init do |config| 
    config.dsn = ENV["SENTRY_DNS"]
    config.breadcrumbs_logger = [:active_support_logger, :http_logger]
    # config.enabled_environments = %w[production]

    # Set traces_sample_rate to 1.0 to capture 100%
    # of transactions for performance monitoring.
    config.traces_sample_rate = 1.0
  end
end