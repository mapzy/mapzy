# frozen_string_literal: true

module Sync
  class LocationSync
    attr_reader :locations_payload

    def initialize(locations_payload, map_id)
      # locations_payload must be an array
      @locations_payload = locations_payload
      @map = Map.find(map_id)
      @locations_to_insert = []
    end

    def synchronize!
      build_locations
      ActiveRecord::Base.transaction do
        destroy_existing_locations
        create_new_locations
      end
    end

    def validate!
      build_locations
      @locations_to_insert.each do |l|
        next if l.valid?

        raise ArgumentError, l.errors.full_messages.first
      end
    end

    private

    def validate_required_keys!(location)
      # make the user has provided the min. required keys
      unless location_name_present?(location)
        raise ArgumentError, "You must include a value for the 'name' key"\
                             " in all of your location objects."
      end

      return if address_or_coordinates_present?(location)

      raise ArgumentError, "You must either include a value for 'address'"\
                             " or values 'latitude' and 'longitude' in all your location objects."
    end

    def build_locations
      @locations_to_insert = @map.locations.build(@locations_payload)
    end

    def destroy_existing_locations
      Location.destroy_all
    end

    def create_new_locations
      Location.import!(@locations_to_insert, recursive: true)
    end
  end
end
