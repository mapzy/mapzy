# frozen_string_literal: true

module LocationHelper
  # Default bounds are set to Europe
  DEFAULT_BOUNDS = [[-30, 25], [60, 75]].freeze

  # Converts an array of ActiveRecord locations into GeoJSON.
  #
  # @return [Hash] GeoJson format
  def to_geo_json(locations)
    feature_collection = {
      type: "FeatureCollection",
      features: []
    }

    locations.each do |location|
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

  # Define the geographical limits in which the map can be shown fully, given its locations
  # @param location_s [Location or Array<Location>]
  # @return [Array] Containing the bottom-right (west, south) & top-left (east, north) limits
  def bounds(location_s)
    features = to_geo_json([*location_s])[:features]

    return DEFAULT_BOUNDS if features.blank?

    lats = features.map { |f| f[:geometry][:coordinates][1] }
    longs = features.map { |f| f[:geometry][:coordinates][0] }

    west, east = longs.minmax
    south, north = lats.minmax

    [[west, south], [east, north]]
  end

  def no_opening_times?(location)
    location.id.present? && location.opening_times.empty?
  end

  def edit_or_finalise(location)
    location.geocoding_error? ? "Finalize" : "Edit"
  end

  def error_message
    "Unfortunately, we were not able to find all your addresses.
    Please finalize them in the list below."
  end

  def pending_message
    "Your locations are being processed in the background.
    This may take a couple of minutes."
  end
end
