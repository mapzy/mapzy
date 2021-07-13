# frozen_string_literal: true

# == Schema Information
#
# Table name: locations
#
#  id           :bigint           not null, primary key
#  address      :string
#  city         :string
#  country_code :string
#  description  :text
#  latitude     :decimal(15, 10)
#  longitude    :decimal(15, 10)
#  name         :string
#  state        :string
#  zip_code     :string
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  map_id       :bigint           not null
#
# Indexes
#
#  index_locations_on_map_id  (map_id)
#
# Foreign Keys
#
#  fk_rails_...  (map_id => maps.id)
#
require 'rails_helper'

RSpec.describe Location, type: :model do
  describe 'factory' do
    it 'has a valid factory' do
      expect(build(:location)).to be_valid
    end
  end

  describe 'associations' do
    it { is_expected.to belong_to(:map) }
  end

  describe 'validations' do
    before { create(:location) }

    context 'with address' do
      it { is_expected.to validate_presence_of :address }
    end

    context 'with city' do
      it { is_expected.to validate_presence_of :city }
    end

    context 'with zip_code' do
      it { is_expected.to validate_presence_of :zip_code }
    end

    context 'with country_code' do
      it { is_expected.to validate_presence_of :country_code }
    end

    context 'with name' do
      it { is_expected.to validate_presence_of :name }
    end
  end

  describe '.full_address' do
    let(:location) { create(:location) }

    it 'has the correct full address' do
      expect(location.full_address).to eq 'Hohlstrasse 117, 8004, Zürich, Switzerland'
    end
  end

  describe 'country' do
    let(:location) { create(:location) }

    it 'has the correct country' do
      expect(location.country_name).to eq 'Switzerland'
    end
  end

  describe '.eligible_for_geocoding?' do
    context 'when latitude & longitude are present' do
      let(:location) { create(:location, latitude: 52.4937207, longitude: 13.4171431) }

      context 'when address changes' do
        it 'does not update latitude' do
          prev_latitude = location.latitude
          location.address = 'Käshaldenstrasse 41'
          location.zip_code = '8052'
          location.save

          expect(location.latitude).to eq prev_latitude
        end

        it 'updates longitude' do
          prev_longitude = location.longitude
          location.address = 'Käshaldenstrasse 41'
          location.zip_code = '8052'
          location.save

          expect(location.longitude).to eq prev_longitude
        end
      end
    end

    context 'when latitude or latitude are missing' do
      let(:location) { build(:location, latitude: nil, longitude: nil) }

      context 'when address changes' do
        it 'updates latitude' do
          prev_latitude = location.latitude
          location.address = 'Käshaldenstrasse 41'
          location.zip_code = '8052'
          location.save

          expect(location.latitude).not_to eq prev_latitude
        end

        it 'updates longitude' do
          prev_longitude = location.longitude
          location.address = 'Käshaldenstrasse 41'
          location.zip_code = '8052'
          location.save

          expect(location.longitude).not_to eq prev_longitude
        end
      end
    end
  end
end
