# frozen_string_literal: true

module Sync
  # this class expects a locations payload (according to a predefined structure) and a map id
  # the goal is to synchronize the locations from the payload with the ones that exist in the database
  # 1) check if location with :id exists, if not add, if yes update info if necessary
  # 2) delete all locations that were not included in this payload

  class LocationSync
    def initialize(locations_payload, map_id)
      @locations_payload = locations_payload
      @map = Map.find(map_id)
      @locations_db = @map.locations.includes(:opening_times)

      @locations_stale = calc_stale_locations
      @locations_to_insert = []
      @locations_to_update = []
      @opening_times_to_update = []
    end

    def synchronize!
      @locations_payload.each { |lp| categorize_location(lp) }
      update_database!
    end

    def validate!
      # just validate without updating database so that we can return errors in response if necessary
      @locations_payload.each { |lp| categorize_location(lp) }
    end

    def update_database!
      destroy_locations_without_id!

      destroy_stale_locations!

      import_updated_locations!

      import_new_locations!

      import_new_and_updated_opening_times!
    end

    def categorize_location(lp)
      # figure out to insert or update this location, or to update its opening times
      matched = false
      otp = lp[:opening_times]
      # update attributes of opening times we got from the payload to compare to database opening times

      lp[:map_id] = @map.id
      lp[:external_id] = lp.delete :id

      @locations_db.each do |ld|
        next unless lp[:external_id] == ld.external_id

        # convert locations and opening times from activerecord to hash
        ld_hash = LocationSync.location_ar_to_hash(ld)
        otd_hash = LocationSync.opening_times_ar_to_hash(ld.opening_times)

        include_location_if_changed(lp, ld_hash)
        include_opening_times_if_changed(otp, otd_hash, ld)

        matched = true
        break
      end
      # if location from payload doesn't exist in current database, we will add it
      include_location_if_new(lp) unless matched
    end

    def include_location_if_changed(location_payload, location_database)
      # find changed locations that we need to update

      location_payload = location_payload.except(:opening_times)
      location_database = location_database.except("id")
      unless LocationComparison.new(location_payload.except("map_id"), location_database).changed?
        return
      end

      @locations_to_update.push(@map.locations.build(LocationComparison.strong_params(location_payload)))
    end

    def include_opening_times_if_changed(ot_payload, ot_database, location_database)
      # find changed opening times that we need to update
      # we update all opening times per location, even if only one part changed

      ot_payload = OpeningTimesComparison.prepare_attributes(ot_payload, location_database.id)
      return unless OpeningTimesComparison.new(ot_payload, ot_database).changed?

      @opening_times_to_update.concat(location_database.opening_times.build(ot_payload))
    end

    def include_location_if_new(location_payload)
      @locations_to_insert.push(@map.locations.build(LocationComparison.strong_params(lp)))
    end

    def destroy_locations_without_id!
      # delete all locations without an external_id
      @map.locations.where(external_id: [nil, ""]).destroy_all
    end

    def destroy_stale_locations!
    end

    def import_updated_locations!
      # update locations in database
      updated_locations = Location.import(
        @locations_to_update,
        on_duplicate_key_update: {
          conflict_target: %i[map_id external_id],
          columns: %i[name description address latitude longitude]
        }
      )
    end

    def import_new_locations!
    end

    def import_new_and_updated_opening_times!
      # update opening times in database
      updated_ots = OpeningTime.import(
        @opening_times_to_update,
        on_duplicate_key_update: {
          conflict_target: %i[location_id day],
          columns: %i[opens_at closes_at closed open_24h]
        }
      )
    end

    def calc_stale_locations
      @locations_db.map { |l| l[:id] } - @locations_payload.map { |l| l[:id] }
    end

    def self.location_ar_to_hash(location_active_record)
      loc_attr_except = %w[created_at updated_at map_id]
      location_active_record.as_json.except(*loc_attr_except)
    end

    def self.opening_times_ar_to_hash(opening_times_active_record)
      ot_attr_except = %w[created_at updated_at]
      opening_times_active_record.map { |ot| ot.as_json.except(*ot_attr_except) }
    end
  end
end
