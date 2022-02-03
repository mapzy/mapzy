# frozen_string_literal: true

class LocationsController < ApplicationController
  after_action :track_view_location_event, only: %i[show]

  def new; end

  def create; end

  def show
    @location = Location.find(params[:id])
  end

  private

  def track_view_location_event
    FuguWorker.perform_async("Viewed Location")
  end
end
