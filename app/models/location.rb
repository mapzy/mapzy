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
#  map_id      :bigint           not null
#
# Indexes
#
#  index_locations_on_map_id  (map_id)
#
# Foreign Keys
#
#  fk_rails_...  (map_id => maps.id)
#
class Location < ApplicationRecord
  include Hashid::Rails

  belongs_to :map
  has_many :opening_times, dependent: :destroy

  accepts_nested_attributes_for :opening_times, allow_destroy: true

  validates :address, presence: true
  validates :name, presence: true

  before_validation :geocode_as_pending, if: :skip_geocoding
  after_validation :geocode, if: :eligible_for_geocoding?, unless: :skip_geocoding

  geocoded_by :address

  attr_accessor :skip_geocoding

  scope :geocoding_success, -> { where.not(latitude: [nil, 0]).where.not(longitude: [nil, 0]) }
  scope :geocoding_error, -> { where(latitude: nil).or(where(longitude: nil)) }
  scope :geocoding_pending, -> { where(latitude: 0, longitude: 0) }

  scope :order_by_unfinished, -> { order("ABS(latitude) ASC NULLS FIRST") }

  def eligible_for_geocoding?
    !skip_geocoding && address_changed? && !latitude && !longitude
  end

  def geocode_as_pending
    self.latitude = 0
    self.longitude = 0
  end

  def geocoding_error?
    latitude.blank? || longitude.blank?
  end

  def geocoding_success?
    latitude.present? && longitude.present? && !null_island
  end

  def geocoding_pending?
    latitude.present? && longitude.present? && null_island
  end

  def null_island
    latitude&.zero? && longitude&.zero?
  end

  def bbox
    geocoding_success? ? self : map.locations.geocoding_success
  end
end
