# frozen_string_literal: true

# == Schema Information
#
# Table name: locations
#
#  id           :bigint           not null, primary key
#  address      :string
#  city         :string
#  country_code :string
#  description  :text
#  latitude     :decimal(15, 10)
#  longitude    :decimal(15, 10)
#  name         :string
#  state        :string
#  zip_code     :string
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  map_id       :bigint           not null
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
  belongs_to :map
  has_many :opening_times, dependent: :destroy

  validates :address, :city, :zip_code, :country_code, :name, presence: true

  before_validation :country_to_country_code
  after_validation :geocode, if: :eligible_for_geocoding?
  before_save :country_code_to_upcase

  geocoded_by :full_address

  def full_address
    [address, zip_code, city, state, country].compact.join(', ')
  end

  def country
    @country ||= ISO3166::Country.find_country_by_alpha2(country_code)&.unofficial_names&.first
  end

  attr_writer :country

  def country_to_country_code
    return unless country

    country_alpha2 = ISO3166::Country.find_country_by_name(country)
    self.country_code = country_alpha2.alpha2 if country_alpha2
  end

  def country_code_to_upcase
    country_code.upcase!
  end

  def eligible_for_geocoding?
    full_address_has_changes? && !latitude && !longitude
  end

  def full_address_has_changes?
    address_changed? || zip_code_changed? || city_changed? ||
      state_changed? || country_code_changed?
  end
end
