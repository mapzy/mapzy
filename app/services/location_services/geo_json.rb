# frozen_string_literal: true

module LocationServices
  class GeoJson
    def initialize(locations)
      @locations = locations
    end

    def convert_to_geo_json_hash
      feature_collection = {
        type: 'FeatureCollection',
        features: []
      }

      @locations.find_each do |location|
        feature_collection[:features].push(
          {
            type: 'Feature',
            geometry: {
              type: 'Point',
              coordinates: [location.longitude.to_f, location.latitude.to_f]
            },
            properties: {
              id: location.id
            }
          }
        )
      end
      feature_collection
    end
  end
end
