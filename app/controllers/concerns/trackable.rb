# frozen_string_literal: true

module Trackable
  extend ActiveSupport::Concern

  def track_event(name = "", properties = {})
    return unless ENV["FUGU_API_KEY"] && ENV["FUGU_URL"]

    # default if no event name is provided
    name = "Viewed #{controller_name} #{action_name}" if name.empty?
    FuguWorker.perform_async_with_failover(name, properties)
  end
end
