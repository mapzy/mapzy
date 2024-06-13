# frozen_string_literal: true

class MapsController < ApplicationController
  include Trackable

  around_action :switch_locale, only: %i[show]

  after_action :allow_iframe, only: %i[show]
  after_action -> { track_event("Viewed Map", hashid: @map.hashid) }, only: %i[show]

  def show
    @map = Map.find(params[:id])
    @locations = @map.locations.geocoding_success
    @ask_location_permission = true
  end

  private

  def allow_iframe
    response.headers.except! "X-Frame-Options"
  end
end
