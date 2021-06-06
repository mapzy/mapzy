# frozen_string_literal: true

module Dashboard
  class MapsController < DashboardController
    load_and_authorize_resource

    def index
      # Currently an user can have a single map
      # Thus, we redirect the user to her default map
      redirect_to map_path(current_user.find_or_create_default_map)
    end

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
end
