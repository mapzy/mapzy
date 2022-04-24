# frozen_string_literal: true

# == Schema Information
#
# Table name: locations
#
#  id               :bigint           not null, primary key
#  address          :string
#  description      :text
#  geocoding_status :integer          default("pending"), not null
#  latitude         :decimal(15, 10)
#  longitude        :decimal(15, 10)
#  name             :string
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  map_id           :bigint           not null
#
# Indexes
#
#  index_locations_on_geocoding_status  (geocoding_status)
#  index_locations_on_map_id            (map_id)
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

  enum geocoding_status: { pending: 0, success: 1, error: 2 }

  validates :address, presence: true
  validates :name, presence: true
  validates :geocoding_status, presence: true

  after_validation :geocode, if: :eligible_for_geocoding?

  geocoded_by :address

  def eligible_for_geocoding?
    address_changed? && !latitude && !longitude
  end

  def geocode
    super
    self.geocoding_status = \
      if latitude.present? && longitude.present?
        :success
      else
        :error
      end
  end
end
