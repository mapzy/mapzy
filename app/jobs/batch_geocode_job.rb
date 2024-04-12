# frozen_string_literal: true

class BatchGeocodeJob < ApplicationJob
  retry_on StandardError, attempts: 10

  def perform(map_id)
    map = Map.find_by(id: map_id)
    return if map.nil?

    locations_to_geocode = map.locations.geocoding_pending
    return if locations_to_geocode.empty?

    # Mapbox Geocoding limit is 600 per minute, we geocode max. 500 locations per batch
    # @see https://docs.mapbox.com/api/search/geocoding/#geocoding-restrictions-and-limits
    locations_to_geocode.find_in_batches(batch_size: 500).with_index do |group, batch|
      group.each do |location|
        location.geocode
        location.save
      end

      sleep(60) unless batch.zero?
    end

    # If we still have pending locations at this stage, retry the worker
    count_after = map.locations.geocoding_pending.count
    raise "There are still #{count_after} pending locations to geocode" if count_after.positive?
  end
end
