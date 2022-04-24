# frozen_string_literal: true

# == Schema Information
#
# Table name: locations
#
#  id               :bigint           not null, primary key
#  address          :string
#  description      :text
#  geocoding_status :integer          default("pending"), not null
#  latitude         :decimal(15, 10)
#  longitude        :decimal(15, 10)
#  name             :string
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  map_id           :bigint           not null
#
# Indexes
#
#  index_locations_on_geocoding_status  (geocoding_status)
#  index_locations_on_map_id            (map_id)
#
# Foreign Keys
#
#  fk_rails_...  (map_id => maps.id)
#
require "rails_helper"

RSpec.describe Location, type: :model do
  describe "attributes" do
    it do
      is_expected.to define_enum_for(:geocoding_status) \
        .with_values(pending: 0, error: 1, success: 2)
    end
  end

  describe "associations" do
    it { is_expected.to belong_to(:map) }
  end

  describe "validations" do
    before { create(:location) }

    it { is_expected.to validate_presence_of :address }
    it { is_expected.to validate_presence_of :name }
    it { is_expected.to validate_presence_of :geocoding_status }
  end

  describe "#eligible_for_geocoding?" do
    subject { location.eligible_for_geocoding? }

    let(:new_address) { "Kashaldenstrasse 41, 8052" }

    context "when latitude & longitude are present" do
      let(:location) { create(:location, latitude: 52.4937207, longitude: 13.4171431) }

      context "when address changes" do
        it "is NOT eligible_for_geocoding" do
          location.address = new_address
          expect(subject).to be(false)
        end
      end
    end

    context "when latitude or latitude are missing" do
      let(:location) { build(:location, latitude: nil, longitude: nil) }

      context "when address changes" do
        it "is eligible_for_geocoding" do
          location.address = new_address
          expect(subject).to be(true)
        end
      end
    end
  end

  describe "#geocode" do
    let(:location) do
      create(:location, latitude: nil, longitude: nil, address: "Paris", geocoding_status: :pending)
    end

    context "when the geocoding works" do
      it "adds the latitude" do
        location.geocode
        expect(location.latitude).not_to be_nil
      end

      it "adds the longitude" do
        location.geocode
        expect(location.longitude).not_to be_nil
      end

      it "changes the geocoding_status to :success" do
        location.geocode
        expect(location.geocoding_status).to eq("success")
      end
    end

    context "when the geocoding doesn't work" do
      before do
        Geocoder::Lookup::Test.add_stub("Paris", [{ coordinates: [nil, nil] }])
      end

      it "does not add the latitude" do
        location.geocode
        expect(location.latitude).to be_nil
      end

      it "does not add the longitude" do
        location.geocode
        expect(location.longitude).to be_nil
      end

      it "changes the geocoding_status to :error" do
        location.geocode
        expect(location.geocoding_status).to eq("error")
      end
    end
  end
end
