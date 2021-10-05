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
class OpeningTime < ApplicationRecord
  belongs_to :location

  enum day: { mon: 1, tue: 2, wed: 3, thu: 4, fri: 5, sat: 6, sun: 7 }

  validates :day, presence: true
  validates :day, uniqueness: { scope: :location_id }
  validates :open_24h, inclusion: { in: [true, false] }
end
