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

  after_validation :geocode, if: :eligible_for_geocoding?

  geocoded_by :address

  def eligible_for_geocoding?
    address_changed? && !latitude && !longitude
  end
end
