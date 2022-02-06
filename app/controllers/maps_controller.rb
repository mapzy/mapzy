# frozen_string_literal: true

class MapsController < ApplicationController
  include Trackable

  after_action :allow_iframe, only: %i[show]
  after_action -> { track_event("Viewed Map") }, only: %i[show]

  def show
    @map = Map.find(params[:id])
    @location_base_url = locations_path
    @ask_location_permission = true
  end

  private

  def allow_iframe
    response.headers.except! "X-Frame-Options"
  end
end
