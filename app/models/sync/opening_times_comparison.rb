# frozen_string_literal: true

module Sync
  class OpeningTimesComparison
    # this class expects both opening_times as hashes with string keys
    def initialize(new_opening_times, existing_opening_times)
      @new_ots = new_opening_times
      @existing_ots = existing_opening_times

      OpeningTimesComparison.validate_opening_times!(@new_ots)
    end

    def changed?
      @new_ots.each do |new_ot|
        # check if the same day exists in database
        ot_same_day = @existing_ots.find { |ex_ot| ex_ot["day"] == new_ot["day"] }
        return true unless ot_same_day

        # this could be tricky for some edge cases, maybe come up with a better solution
        ot_same_day["opens_at"] = Time.zone.parse(ot_same_day["opens_at"]).strftime("%H:%M")
        ot_same_day["closes_at"] = Time.zone.parse(ot_same_day["closes_at"]).strftime("%H:%M")
        return true if new_ot != ot_same_day.except("id")
      end
      false
    end

    def self.validate_opening_times!(opening_times)
      if duplicate_day?(opening_times)
        raise ArgumentError, "Opening hours can't include one day more than once."
      end

      return if all_days_present?(opening_times)

      raise ArgumentError, "You must include an opening hour object for each day of the week."
    end

    def self.duplicate_day?(opening_times)
      opening_times.group_by { |ot| ot["day"] }.values.select { |d| d.size > 1 }.present?
    end

    def self.all_days_present?(opening_times)
      days = opening_times.map { |ot| ot["day"] }
      OpeningTime.days.keys == days
    end

    def self.prepare_attributes(opening_times_payload, location_id)
      # prepares attributes from payload object so that we can compare it better
      opening_times_payload.map do |ots|
        ots["location_id"] = location_id
        OpeningTimesComparison.strong_params_ot(ots).to_h
      end
    end

    def self.strong_params_ot(ot_params)
      ot_params.permit(%i[location_id day opens_at closes_at closed open_24h])
    end
  end
end
