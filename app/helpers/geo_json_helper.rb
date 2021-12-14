# frozen_string_literal: true

module GeoJsonHelper
  # Convert a collection of locations to GeoJson format
  #
  # @see https://geojson.org/
  # @param [ActiveRecord::Associations::CollectionProxy] Locations
  # @return [Hash] GeoJson format
  def self.convert(locations)
    feature_collection = {
      type: "FeatureCollection",
      features: []
    }

    locations.find_each do |location|
      feature_collection[:features].push(
        {
          type: "Feature",
          geometry: {
            type: "Point",
            coordinates: [location.longitude.to_f, location.latitude.to_f]
          },
          properties: {
            hashid: location.hashid
          }
        }
      )
    end
    feature_collection
  end
end
