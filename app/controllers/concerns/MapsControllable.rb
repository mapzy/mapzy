# frozen_string_literal: true

module MapsControllable
  extend ActiveSupport::Concern

  def show
    locations = Location.where(map_id: params[:id])

    markers = LocationServices::GeoJson
              .new(locations)
              .convert_to_geo_json_hash

    lats = markers[:features].map { |f| f[:geometry][:coordinates][1] }
    longs = markers[:features].map { |f| f[:geometry][:coordinates][0] }

    west, east = longs.minmax
    south, north = lats.minmax

    @bounds = [[west, south], [east, north]]

    @markers_json = markers.to_json
  end
end
