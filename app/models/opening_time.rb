# frozen_string_literal: true

# == Schema Information
#
# Table name: opening_times
#
#  id           :bigint           not null, primary key
#  closing_time :time
#  open_24h     :boolean          default(FALSE), not null
#  opening_time :time
#  weekday      :integer          not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  location_id  :bigint
#
# Indexes
#
#  index_opening_times_on_location_id              (location_id)
#  index_opening_times_on_weekday_and_location_id  (weekday,location_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (location_id => locations.id)
#
class OpeningTime < ApplicationRecord
  belongs_to :location

  enum weekday: { mon: 1, tue: 2, wed: 3, thu: 4, fri: 5, sat: 6, sun: 7 }

  validates :weekday, presence: true
  validates :weekday, uniqueness: { scope: :location_id }
  validates :open_24h, inclusion: { in: [true, false] }
end
