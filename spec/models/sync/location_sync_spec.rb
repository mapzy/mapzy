# frozen_string_literal: true

require "rails_helper"

RSpec.describe Sync::LocationSync, type: :model do
  let(:user) { create(:user, account: create(:account), map: create(:map)) }

  let(:locations_payload) { locations_payload_data }

  context "with initializing" do
    describe ".initialize" do
      it "doesn't raise an error" do
        expect { described_class.new(locations_payload, user.map.id) }.not_to raise_error
      end
    end
  end

  context "with class methods" do
    describe ".validate!" do
      it "doesn't raise error" do
        location_sync = described_class.new(locations_payload, user.map.id)
        expect { location_sync.validate! }.not_to raise_error
      end

      it "doesn't raise error without opening times" do
        locations_payload.first.delete(:opening_times_attributes)
        location_sync = described_class.new(locations_payload, user.map.id)
        expect { location_sync.validate! }.not_to raise_error
      end

      it "raises error for missing location name" do
        locations_payload.first[:name] = ""
        location_sync = described_class.new(locations_payload, user.map.id)
        expect { location_sync.validate! }.to raise_error(ArgumentError, /Name/)
      end

      it "raises error for missing address" do
        locations_payload.first[:address] = ""
        location_sync = described_class.new(locations_payload, user.map.id)
        expect { location_sync.validate! }.to raise_error(ArgumentError, /Address/)
      end

      it "raises error for missing day of the week" do
        locations_payload.first[:opening_times_attributes].shift
        location_sync = described_class.new(locations_payload, user.map.id)
        expect { location_sync.validate! }.to raise_error(ArgumentError, /Opening times/)
      end

      it "raises error for missing opening hours value" do
        locations_payload.first[:opening_times_attributes].first[:opens_at] = ""
        location_sync = described_class.new(locations_payload, user.map.id)
        expect { location_sync.validate! }.to raise_error(ArgumentError, /opens at can't be blank/)
      end
    end

    describe ".synchronize!" do
      it "create the correct locations" do
        location_sync = described_class.new(locations_payload, user.map.id)
        location_sync.synchronize!

        expect(Location.where(name: locations_payload.first[:name])).to exist
      end

      it "deletes existing locations" do
        create(:location, name: "old location", map: user.map)

        location_sync = described_class.new(locations_payload, user.map.id)
        location_sync.synchronize!

        expect(Location.where(name: "old location")).not_to exist
      end
    end
  end
end
