# frozen_string_literal: true

require "rails_helper"

RSpec.describe SyncWorker, type: :worker do
  let(:user) { create(:user, account: create(:account), map: create(:map)) }

  let(:locations_payload) { locations_payload_data }

  let(:payload_dump) { create(:sync_payload_dump, map: user.map, payload: locations_payload) }

  describe "perform" do
    context "with valid payload" do
      it "creates the correct location" do
        subject.perform(payload_dump.id)
        expect(Location.where(name: locations_payload.first[:name])).to exist
      end

      it "doesn't raise error" do
        expect { subject.perform(payload_dump.id) }.not_to raise_error
      end

      it "sets the status to 'processed'" do
        subject.perform(payload_dump.id)
        payload_dump.reload
        expect(payload_dump.processed?).to be true
      end
    end

    context "with invalid payload" do
      before do
        locations_payload.first[:name] = ""
        payload_dump.payload = locations_payload
        payload_dump.save
      end

      it "doesn't create a location" do
        subject.perform(payload_dump.id)
        expect(Location.where(name: locations_payload.first[:name])).not_to exist
      end

      it "sets the status to 'error'" do
        subject.perform(payload_dump.id)
        payload_dump.reload
        expect(payload_dump.error?).to be true
      end
    end
  end
end
