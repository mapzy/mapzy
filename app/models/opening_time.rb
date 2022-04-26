# frozen_string_literal: true

# == Schema Information
#
# Table name: opening_times
#
#  id          :bigint           not null, primary key
#  closed      :boolean          default(FALSE), not null
#  closes_at   :time
#  day         :integer          not null
#  open_24h    :boolean          default(FALSE), not null
#  opens_at    :time
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  location_id :bigint
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
  ALL_DAYS = WEEKDAY + WEEKEND

  belongs_to :location

  enum day: { monday: 1, tuesday: 2, wednesday: 3, thursday: 4, friday: 5, saturday: 6, sunday: 7 }

  validates :day, presence: true
  validates :day, uniqueness: { scope: :location_id }
  validates :closed, inclusion: { in: [true, false] }
  validates :open_24h, inclusion: { in: [true, false] }

  validates :opens_at, presence: true, unless: -> { closed || open_24h? }
  validates :closes_at, presence: true, unless: -> { closed || open_24h? }

  scope :weekday, -> { where(day: WEEKDAY) }
  scope :weekend, -> { where(day: WEEKEND) }

  # Render the opening time
  #
  def to_s
    if closed
      "#{day.capitalize}: closed"
    elsif open_24h
      "#{day.capitalize}: open 24h"
    elsif opens_at && closes_at
      "#{day.capitalize}: #{opens_at.strftime('%H:%M')} - #{closes_at.strftime('%H:%M')}"
    end
  end

  # Build 7 opening times objects, each for a day of the week, with default values:
  # - open from 08:00 to 18:00 on weekdays
  # - closed on weekends
  #
  def self.build_default
    records = []

    WEEKDAY.each do |day|
      records << new(day: day, opens_at: "08:00", closes_at: "18:00")
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
    minutes = %w[00 30]

    hours.each do |h|
      minutes.each do |min|
        res << "#{h}:#{min}"
      end
    end

    res
  end
end
