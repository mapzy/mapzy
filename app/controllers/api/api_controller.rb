# frozen_string_literal: true

module Api
  class ApiController < ApplicationController
    skip_before_action :verify_authenticity_token

    before_action :set_map

    around_action :handle_exceptions

    private

    def handle_exceptions
      begin
        yield
      rescue ActiveRecord::RecordNotFound => e
        @status = 404
        @error_type = e.class.to_s
      rescue ActionController::UnfilteredParameters => e
        @status = 422
        @message = "Your payload contains unpermitted parameters."\
                   " Please double check with our docs."
        @error_type = e.class.to_s
      rescue ArgumentError => e
        @status = 422
        @error_type = e.class.to_s
      rescue StandardError => e
        @status = 500
        @error_type = e.class.to_s
      end

      return if e.instance_of?(NilClass)

      render json: { error: { type: @error_type, message: @message || e.message } },
             status: @status
    end

    def bearer_token
      pattern = /^Bearer /
      header = request.headers["Authorization"]
      header&.gsub(pattern, "") if header.match(pattern)
    end

    def authorize_bearer_token
      return if bearer_token && @map.api_key.key_value == bearer_token

      render json: {
               error: {
                 type: "Unauthorized",
                 message: "The API key you provided is not valid"\
                          " for the map with id '#{params[:map_id]}'"
               }
             },
             status: :unauthorized
    rescue StandardError => e
      Sentry.capture_exception(e)
      render json: { error: { type: e.class.to_s, message: e.message } },
             status: :unauthorized
    end

    def set_map
      @map = Map.find(params[:map_id])
    end
  end
end
