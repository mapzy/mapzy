# frozen_string_literal: true

module Sync
  class LocationComparison
    # this class expects both locations as hashes with string keys
    def initialize(new_location, existing_location)
      @new_location = new_location
      @existing_location = existing_location
    end

    def changed?
      @new_location != @existing_location
    end

    def self.strong_params(location_params)
      # rename params
      if location_params.key?(:opening_times)
        location_params[:opening_times_attributes] = location_params.delete :opening_times
      end

      location_params.permit(:map_id, :name, :description, :address, :latitude, :longitude, :external_id,
                             opening_times_attributes: \
                               %i[day opens_at closes_at closed open_24h _destroy])
    end
  end
end
