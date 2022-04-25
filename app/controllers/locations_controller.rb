# frozen_string_literal: true

class LocationsController < ApplicationController
  include Trackable

  before_action :set_map
  after_action -> { track_event("Viewed Location") }, only: %i[show]

  def show
    @location = Location.find(params[:id])
  end

  def index
    @locations = @map.locations.geocoding_success
  end

  private

  def set_map
    @map = Map.find(params[:map_id])
  end
end
