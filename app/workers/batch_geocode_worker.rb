# frozen_string_literal: true

class BatchGeocodeWorker
  include Sidekiq::Worker

  def perform(map_id)
    map = Map.find(map_id)
    return if map.nil?

    locations_to_geocode = map.locations.where(geocoding_status: "pending")
    return if locations_to_geocode.empty?

    locations_to_geocode.each do |location|
      location.geocode
      location.save

      # Mapbox Geocoding limit is 10 per second
      # @see https://docs.mapbox.com/api/search/geocoding/#geocoding-restrictions-and-limits
      sleep(0.15)
    end
  end
end
