# frozen_string_literal: true

module Api
  module V1
    class MapsController < Api::ApiController
      before_action :authorize_bearer_token

      def sync
        unless @map.sync_mode
          raise ArgumentError, "Sync mode is turned off."\
                               " Please turn on Sync mode in your Dashboard to use this API."
        end

        payload = params[:_json]
        Sync::LocationSync.new(payload, @map.id).synchronize!

        # if valid, dump payload to database and start background job
        payload_dump = Sync::PayloadDump.create!(map: @map, payload: payload)

        Rails.logger.debug "payload init"
        Rails.logger.debug payload

        Rails.logger.debug "payload from db"
        Rails.logger.debug payload_dump.payload

        SyncWorker.perform_async(payload_dump.id)
      end
    end
  end
end
