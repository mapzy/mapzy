# frozen_string_literal: true

class BatchGeocodeWorker
  include Sidekiq::Worker

  def perform(map_id)
    map = Map.find(map_id)
    return if map.nil?

    locations_to_geocode = map.locations.geocoding_pending
    return if locations_to_geocode.empty?

    # Mapbox Geocoding limit is 600 per minute, we geocode max. 500 locations per batch
    # @see https://docs.mapbox.com/api/search/geocoding/#geocoding-restrictions-and-limits
    locations_to_geocode.find_in_batches(batch_size: 500) do |group|
      group.each do |location|
        location.geocode
        location.save
      end

      sleep(60)
    end
  end
end
