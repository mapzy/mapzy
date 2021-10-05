# frozen_string_literal: true

# == Schema Information
#
# Table name: opening_times
#
#  id           :bigint           not null, primary key
#  closing_time :time
#  day          :integer          not null
#  open_24h     :boolean          default(FALSE), not null
#  opening_time :time
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  location_id  :bigint
#
# Indexes
#
#  index_opening_times_on_day_and_location_id  (day,location_id) UNIQUE
#  index_opening_times_on_location_id          (location_id)
#
# Foreign Keys
#
#  fk_rails_...  (location_id => locations.id)
#
require 'rails_helper'

RSpec.describe OpeningTime, type: :model do
  describe 'attributes' do
    it do
      is_expected.to define_enum_for(:day)
        .with_values(mon: 1, tue: 2, wed: 3, thu: 4, fri: 5, sat: 6, sun: 7)
    end
  end

  describe 'associations' do
    it { is_expected.to belong_to(:location) }
  end

  describe 'validations' do
    let(:location) { create(:location) }

    it { is_expected.to validate_inclusion_of(:open_24h).in_array([true, false]) }

    it 'is expected to validate that :day is unique, scoped_by :location_id' do
      described_class.create(day: 1, location: location)
      duplicate = described_class.new(day: 1, location: location)

      expect(duplicate).not_to be_valid
    end
  end
end
