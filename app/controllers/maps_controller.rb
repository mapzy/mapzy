# frozen_string_literal: true

class MapsController < ApplicationController
  def show
    locations = Location.where(map_id: params[:id])

    raise ActiveRecord::RecordNotFound if locations.empty?

    markers = LocationServices::LocationServicesGeoJson
              .new(Location.where(map_id: params[:id]))
              .convert_to_geo_json_hash

    lats = markers[:features].map { |f| f[:geometry][:coordinates][1] }
    longs = markers[:features].map { |f| f[:geometry][:coordinates][0] }

    west, east = longs.minmax
    south, north = lats.minmax

    @bounds = [[west, south], [east, north]]

    @markers_json = markers.to_json
  end
end
