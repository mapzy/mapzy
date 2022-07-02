# frozen_string_literal: true

module Api
  module V1
    class MapsController < Api::ApiController
      before_action :authorize_bearer_token

      def sync
        Sync::LocationSync.new(params[:_json], @map.id).synchronize!

        # if valid, start background job
      end
    end
  end
end
