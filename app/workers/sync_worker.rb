# frozen_string_literal: true

class SyncWorker
  include Sidekiq::Worker

  # we don't want any retries if there's an error, since the incoming data won't have changed
  sidekiq_options retry: 0

  def perform(payload_dump_id)
    payload_dump = Sync::PayloadDump.find(payload_dump_id)
    return unless payload_dump.open?

    payload_dump.processing!

    begin
      Sync::LocationSync.new(payload_dump.payload, payload_dump.map.id).synchronize!
    rescue StandardError => e
      payload_dump.error!
      Sentry.capture_exception(e)
      Rails.logger.error("SyncWorker: #{e.message}")
      return
    end

    payload_dump.processed!
  end
end
