# frozen_string_literal: true

module Dashboard
  class MapsController < DashboardController
    def index
      # Currently an user can have a single map
      # Thus, we redirect the user to her default map
      redirect_to map_path(current_user.find_or_create_default_map)
    end

    def show
      markers = {
        type: 'FeatureCollection',
        features: [
          {
            type: 'Feature',
            geometry: {
              type: 'Point',
              coordinates: [12.554729, 55.70651]
            },
            properties: {
              prop0: 'value0'
            }
          },
          {
            type: 'Feature',
            geometry: {
              type: 'Point',
              coordinates: [12.65147, 55.608166]
            },
            properties: {
              prop0: 'value0'
            }
          }
        ]
      }

      lats = markers[:features].map { |f| f[:geometry][:coordinates][0] }
      longs = markers[:features].map { |f| f[:geometry][:coordinates][1] }

      west, east = lats.minmax
      south, north = longs.minmax

      @bounds = [[west, south], [east, north]]

      @center_coords = [12.550343, 55.665957]
      @markers_json = markers.to_json
    end

    def maps_test
      render html: '<turbo-frame id="location_description">yuhhuuu</turbo-frame>'.html_safe
    end
  end
end
