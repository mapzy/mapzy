# frozen_string_literal: true

# == Schema Information
#
# Table name: locations
#
#  id            :bigint           not null, primary key
#  address_line1 :string
#  address_line2 :string
#  city          :string
#  country_code  :string
#  description   :text
#  latitude      :float
#  longitude     :float
#  name          :string
#  state         :string
#  zip_code      :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  map_id        :bigint           not null
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

    context 'with address_line1' do
      it { is_expected.to validate_presence_of :address_line1 }
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

  describe 'address' do
    let(:location) { create(:location) }

    it 'has the correct address' do
      expect(location.address).to eq 'Hohlstrasse 117, 8004, Zürich, Switzerland'
    end
  end

  describe 'country' do
    let(:location) { create(:location) }

    it 'has the correct country' do
      expect(location.country_name_from_country_code).to eq 'Switzerland'
    end
  end

  describe 'address_changed?' do
    context 'when the address changes' do
      let(:location) { create(:location) }

      it 'updates latitude' do
        prev_latitude = location.latitude
        location.address_line1 = 'Käshaldenstrasse 41'
        location.zip_code = '8052'
        location.save

        expect(location.latitude).not_to eq prev_latitude
      end

      it 'updates longitude' do
        prev_longitude = location.longitude
        location.address_line1 = 'Käshaldenstrasse 41'
        location.zip_code = '8052'
        location.save

        expect(location.longitude).not_to eq prev_longitude
      end
    end

    context 'when latitude and longitude change' do
      let(:location) { create(:location) }

      it 'does not update adress_line1' do
        prev_address_line1 = location.address_line1

        location.latitude = 52.4937207
        location.longitude = 13.4171431

        location.save

        expect(location.address_line1).to eq prev_address_line1
      end
    end
  end
end
