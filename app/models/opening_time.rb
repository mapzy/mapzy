# frozen_string_literal: true

# == Schema Information
#
# Table name: opening_times
#
#  id           :bigint           not null, primary key
#  closed       :boolean          default(FALSE), not null
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
  WEEKDAY = %i[monday tuesday wednesday thursday friday].freeze
  WEEKEND = %i[saturday sunday].freeze

  belongs_to :location

  enum day: { monday: 1, tuesday: 2, wednesday: 3, thursday: 4, friday: 5, saturday: 6, sunday: 7 }

  validates :day, presence: true
  validates :day, uniqueness: { scope: :location_id }
  validates :closed, inclusion: { in: [true, false] }
  validates :open_24h, inclusion: { in: [true, false] }

  scope :weekday, -> { where(day: WEEKDAY) }
  scope :weekend, -> { where(day: WEEKEND) }

  # Build 7 opening times objects, each for a day of the week, with default values:
  # - open from 08:00 to 18:00 on weekdays
  # - closed on weekends
  #
  def self.build_default
    records = []

    WEEKDAY.each do |day|
      records << new(day: day, opening_time: "08:00", closing_time: "18:00")
    end

    WEEKEND.each do |day|
      records << new(day: day, closed: true)
    end

    records
  end

  # Generate opening / closing times options
  # To simplify, only full hours or half hours are proposed
  # e.g. 00:00, 00:30, ..., 23:00, 23:30
  #
  def self.time_options
    res = []
    hours = (0..23).map { |h| format("%02d", h) }
    minutes = ["00", "30"]

    hours.each do |h|
      minutes.each do |min|
        res << "#{h}:#{min}"
      end
    end

    res
  end
end
