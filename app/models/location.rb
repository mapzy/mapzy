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
class Location < ApplicationRecord
  belongs_to :map

  validate :country_exists

  before_save :country_code_to_upcase
  before_validation :convert_country_to_country_code
  after_validation :geocode, if: :address_changed?

  geocoded_by :address

  attr_accessor :country
  attr_accessor :address

  def address
    [address_line_1, zip_code, city, state, ISO3166::Country.find_country_by_alpha2(country_code)].compact.join(', ')
  end

  def convert_country_to_country_code
    if self.country
      country_alpha2 = ISO3166::Country.find_country_by_name(self.country)
      self.country_code = country_alpha2.alpha2 if country_alpha2
    end
  end

  def country_code_to_upcase
    self.country_code.upcase!
  end

  def country_exists
    errors.add(:country_code, "needs to be an existing country") if ISO3166::Country.find_country_by_alpha2(self.country_code).nil?
  end

  def address_changed?
    address_line_1_changed? || zip_code_changed? || city_changed? || state_changed? || country_code_changed?
  end
end
