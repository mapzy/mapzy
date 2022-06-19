# frozen_string_literal: true

module Api
  module V1
    class MapsController < Api::ApiController
      before_action :authorize_bearer_token

      # rubocop:disable Metrics/MethodLength
      # rubocop:disable Metrics/CyclomaticComplexity
      # rubocop:disable Metrics/PerceivedComplexity
      def sync
        locations_payload = params[:_json]

        # 1) check if location with :id exists, if not add, if yes update info if necessary
        # 2) delete all locations that were not included in this payload

        # load all locations from this map into memory
        # save the objects to be deleted to an array
        # save the objects to be updated to an array
        # save the objects to be created to an array

        loc_attr_except = %i[created_at updated_at map_id]
        ot_attr_except = %i[created_at updated_at]

        locations_to_insert = []
        locations_to_update = []
        opening_times_to_update = []

        # delete all locations without an external_id
        @map.locations.where(external_id: [nil, ""]).destroy_all

        locations_db = @map.locations.includes(:opening_times)

        locations_to_del = locations_db.map { |l| l[:id] } - locations_payload.map { |l| l[:id] }

        # figure out which locations to insert or update, and which opening times to update
        locations_payload.each do |lp|
          matched = false
          otp = lp[:opening_times]

          locations_db.each do |ld|
            next unless lp[:id] == ld.external_id

            ld_hash = ld.as_json.symbolize_keys.except(*loc_attr_except)
            otd_hash = ld.opening_times.map { |ot| ot.as_json.symbolize_keys.except(*ot_attr_except) }

            lp_without_ot = lp.except(:opening_times)
            if location_changed?(lp_without_ot, ld_hash)
              locations_to_update.push(@map.locations.build(strong_params_locations(lp_without_ot)))
            end

            otp = otp.map do |ots|
              ots[:location_id] = ld.id
              strong_params_ot(ots).to_h.symbolize_keys
            end

            if opening_times_changed?(otp, otd_hash)
              opening_times_to_update = ld.opening_times.build(otp)
            end

            #matched_location_ids.push(ld.id)
            matched = true
            break
          end
          locations_to_insert.push(@map.locations.build(strong_params_locations(lp))) unless matched
        end

        puts "locations to update"
        puts locations_to_update
        puts "opening times to update"
        puts opening_times_to_update


        updated_locations = Location.import(
          locations_to_update,
          on_duplicate_key_update: {
            conflict_target: %i[map_id external_id],
            columns: %i[name description address latitude longitude]
          }
        )

        updated_ots = OpeningTime.import(
          opening_times_to_update,
          on_duplicate_key_update: {
            conflict_target: %i[location_id day],
            columns: %i[opens_at closes_at closed open_24h]
          }
        )

        # locations_payload.each do |lp|
        #   puts "hehehe"
        #   #puts lp["opening_times"] = format_opening_times(lp["opening_times"])
        #   #locations_to_upsert.push(@map.locations.build(strong_params(lp)))
        #   #ot = lp.delete(:opening_times)
        #   #puts ot
        #   #ot[:location_id] = location_id

        #   #locations_to_upsert.push(@map.locations.build(strong_params_locations(lp)))

        #   #@map.locations.create(strong_params_locations(lp))
        #   lp[:map_id] = @map.id
        #   #Location.upsert(strong_params_locations(lp))

        #   #opening_times_to_upsert.push(@map.locations.build(strong_params_ot(ot)))
        #   #puts lp
        #   #locations_to_upsert.push(strong_params(lp).to_h)
        #   #lp[:map_id] = @map.id
        #   #lp[:external_id] = lp.delete :id
        #   #locations_to_upsert.push(lp.to_h)
        #   #puts lp["opening_times"].first
        #   #OpeningTime.new(lp["opening_times"].first)
        # end

        # puts locations_to_upsert
        # the values in 'columns' will be updated if record with external_id already exists
        # imported_locations = Location.import(
        #   locations_to_upsert,
        #   recursive: true,
        #   on_duplicate_key_update: {
        #     conflict_target: %i[map_id external_id],
        #     columns: %i[name description address latitude longitude]
        #   }
        # )
        #locations_to_upsert.each do { |l| l}

      end

      private

      # def format_opening_times(opening_times)
      #   opening_times.map do |ot|
      #     ot["location_id"] = 
      #   end
      # end

      def strong_params_locations(location_params)
        # rename params
        location_params[:map_id] = @map.id
        location_params[:external_id] = location_params.delete :id
        if location_params.key?(:opening_times)
          location_params[:opening_times_attributes] = location_params.delete :opening_times
        end

        location_params.permit(:map_id, :name, :description, :address, :latitude, :longitude, :external_id,
                               opening_times_attributes: \
                                 %i[day opens_at closes_at closed open_24h _destroy])
      end

      def strong_params_ot(ot_params)
        ot_params.permit(%i[location_id day opens_at closes_at closed open_24h])
      end

      def location_changed?(location_payload, location_db)
        location_db.except(:id) != location_payload
      end

      def opening_times_changed?(ots_payload, ots_db)
        ots_db.each do |ot_db|
          ot_db[:day] = OpeningTime.days[ot_db[:day]]
          ot_same_day = ots_payload.find { |ot| ot[:day] == ot_db[:day] }
          return true unless ot_same_day

          # improve this
          ot_db[:opens_at] = Time.zone.parse(ot_db[:opens_at]).strftime("%H:%M")
          ot_db[:closes_at] = Time.zone.parse(ot_db[:closes_at]).strftime("%H:%M")
          return true if ot_db.except(:id) != ot_same_day
        end
        false
      end
    end
  end
end
