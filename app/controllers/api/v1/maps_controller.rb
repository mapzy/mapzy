# frozen_string_literal: true

module Api
  module V1
    class MapsController < Api::ApiController
      before_action :authorize_bearer_token

      def sync
        puts "heyy"
        locations_payload = params[:_json]

        # 1) check if location with :id exists, if not add, if yes update info if necessary
        # 2) delete all locations that were not included in this payload
      end
    end
  end
end
