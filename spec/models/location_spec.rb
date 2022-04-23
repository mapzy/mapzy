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
        .with_values(pending: 0, success: 1, error: 2)
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

    before do
      new_address_stub = [new_address, [{
        "latitude" => 40.7143528,
        "longitude" => -74.0059731,
        "address" => "New York, NY, USA",
        "state" => "New York",
        "state_code" => "NY",
        "country" => "United States",
        "country_code" => "US"
      }]]

      Geocoder::Lookup::Test.add_stub(new_address_stub[0], new_address_stub[1])
    end

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

  describe "#set_geocoding_status" do
    let(:location) { create(:location, geocoding_status: :pending) }

    context "when not eligible for geocoding" do
      before do
        allow(location).to receive(:eligible_for_geocoding?).and_return(false)
      end

      it "does not change the geocoding_status" do
        location.save!
        expect(location.geocoding_status).to eq("pending")
      end
    end

    context "when eligible for geocoding" do
      before do
        allow(location).to receive(:eligible_for_geocoding?).and_return(true)
        allow(location).to receive(:geocode)
      end

      context "when latitude and longitude are present" do
        it "changes the geocoding_status to :success" do
          location.update!(latitude: 52.4937207, longitude: 13.4171431)
          expect(location.geocoding_status).to eq("success")
        end
      end

      context "when latitude or longitude are missing" do
        it "changes the geocoding_status to :error" do
          location.update!(latitude: nil, longitude: nil)
          expect(location.geocoding_status).to eq("error")
        end
      end
    end
  end
end
