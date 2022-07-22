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

        formatted_payload = format_sync_payload(params[:_json])
        location_sync = Sync::LocationSync.new(formatted_payload, @map.id)
        location_sync.validate!

        # if valid, dump payload to database and start background job
        payload_dump = Sync::PayloadDump.create!(map: @map,
                                                 payload: location_sync.locations_payload)

        SyncWorker.perform_async(payload_dump.id)
      end

      private

      def format_sync_payload(payload)
        # only keeps permitted params and converts to hsah
        payload.map do |l|
          l[:opening_times_attributes] = l.delete :opening_times

          l.permit(:name, :description, :address, :latitude, :longitude,
                   opening_times_attributes: \
                   %i[day opens_at closes_at closed open_24h]).to_h
        end
      end
    end
  end
end
