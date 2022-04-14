# frozen_string_literal: true

require "fugu"

class FuguWorker
  include Sidekiq::Worker
  include Fugu

  def perform(name, properties = {})
    Fugu.track(name, properties)
  end

  def self.perform_async_with_failover(*args)
    return unless ENV["FUGU_URL"]

    # process the job asynchronously
    perform_async(*args)
  rescue Redis::CannotConnectError
    # otherwise, instantiate and perform synchronously
    new.perform(*args)
  end
end
