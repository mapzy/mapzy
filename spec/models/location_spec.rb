# frozen_string_literal: true

# == Schema Information
#
# Table name: locations
#
#  id             :bigint           not null, primary key
#  address_line_1 :string
#  address_line_2 :string
#  city           :string
#  country_code   :string
#  description    :text
#  latitude       :decimal(15, 10)
#  longitude      :decimal(15, 10)
#  name           :string
#  state          :string
#  zip_code       :string
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  map_id         :bigint           not null
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
end