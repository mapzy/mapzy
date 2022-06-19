# frozen_string_literal: true

# == Schema Information
#
# Table name: locations
#
#  id          :bigint           not null, primary key
#  address     :string
#  description :text
#  latitude    :decimal(15, 10)
#  longitude   :decimal(15, 10)
#  name        :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  external_id :string
#  map_id      :bigint           not null
#
# Indexes
#
#  index_locations_on_external_id_and_map_id  (external_id,map_id) UNIQUE
#  index_locations_on_map_id                  (map_id)
#
# Foreign Keys
#
#  fk_rails_...  (map_id => maps.id)
#
require "rails_helper"

RSpec.describe Location, type: :model do
  describe "associations" do
    it { is_expected.to belong_to(:map) }
  end

  describe "validations" do
    before { create(:location) }

    it { is_expected.to validate_presence_of :address }
    it { is_expected.to validate_presence_of :name }
  end

  describe "#eligible_for_geocoding?" do
    subject { location.eligible_for_geocoding? }

    let(:new_address) { "Kashaldenstrasse 41, 8052" }

    before do
      allow(location).to receive(:skip_geocoding).and_return(false)
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

  describe "#geocode" do
    let(:location) do
      create(:location, latitude: nil, longitude: nil, address: "Paris")
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

      it "sets geocoding_success? to true" do
        location.geocode
        expect(location.geocoding_success?).to be true
      end
    end

    context "when the geocoding doesn't work" do
      before do
        Geocoder::Lookup::Test.add_stub("Paris", [{ coordinates: [nil, nil] }])
      end

      it "sets the latitude to zero" do
        location.geocode
        expect(location.latitude).to be_zero
      end

      it "sets the longitude to zero" do
        location.geocode
        expect(location.longitude).to be_zero
      end

      it "sets geocoding_error? to true" do
        location.geocode
        expect(location.geocoding_error?).to be true
      end
    end
  end

  describe "#geocode_as_pending" do
    subject { location.geocode_as_pending }

    let(:location) { build(:location, latitude: nil, longitude: nil) }

    it "sets latitude to nil" do
      subject
      expect(location.latitude).to be_nil
    end

    it "sets longitude to nil" do
      subject
      expect(location.longitude).to be_nil
    end
  end

  describe "#skip_geocoding" do
    context "when skip_geocoding is true" do
      let(:location) { build(:location, skip_geocoding: true) }

      it "doesn't call #geocode" do
        expect(location).not_to receive(:geocode)
        location.save
      end

      it "calls #geocode_as_pending" do
        expect(location).to receive(:geocode_as_pending)
        location.save
      end
    end

    context "when skip_geocoding is null or false" do
      before do
        allow(location).to receive(:eligible_for_geocoding?).and_return(true)
      end

      let(:location) { build(:location) }

      it "doesn't call #geocode_as_pending" do
        expect(location).not_to receive(:geocode_as_pending)
        location.save
      end

      it "calls #geocode" do
        expect(location).to receive(:geocode)
        location.save
      end
    end
  end

  describe "geocoding_pending?" do
    context "when latitude or longitude are blank" do
      let(:location) { create(:location, latitude: nil, longitude: 1) }

      it "returns true" do
        expect(location.geocoding_pending?).to be true
      end
    end

    context "when both latitude and longitude are not null" do
      let(:location) { create(:location, latitude: 1, longitude: 1) }

      it "returns false" do
        expect(location.geocoding_pending?).to be false
      end
    end
  end

  describe "geocoding_success?" do
    context "when latitude or longitude is blank" do
      let(:location) { create(:location, latitude: nil, longitude: 1) }

      it "returns false" do
        expect(location.geocoding_success?).to be false
      end
    end

    context "when latitude and longitude are present" do
      context "when it's null island" do
        let(:location) { create(:location, latitude: 0, longitude: 0) }

        it "returns false" do
          expect(location.geocoding_success?).to be false
        end
      end

      context "when it's not null island" do
        let(:location) { create(:location, latitude: 1, longitude: 1) }

        it "returns true" do
          expect(location.geocoding_success?).to be true
        end
      end
    end
  end

  describe "geocoding_error?" do
    context "when latitude or longitude is blank" do
      let(:location) { create(:location, latitude: nil, longitude: 1) }

      it "returns false" do
        expect(location.geocoding_error?).to be false
      end
    end

    context "when latitude and longitude are present" do
      context "when it's not null island" do
        let(:location) { create(:location, latitude: 1, longitude: 1) }

        it "returns false" do
          expect(location.geocoding_error?).to be false
        end
      end

      context "when it's null island" do
        let(:location) { create(:location, latitude: 0, longitude: 0) }

        it "returns true" do
          expect(location.geocoding_error?).to be true
        end
      end
    end
  end
end
