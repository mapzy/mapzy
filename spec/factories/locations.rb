# frozen_string_literal: true

# == Schema Information
#
# Table name: locations
#
#  id            :bigint           not null, primary key
#  address_line1 :string
#  address_line2 :string
#  city          :string
#  country_code  :string
#  description   :text
#  latitude      :float
#  longitude     :float
#  name          :string
#  state         :string
#  zip_code      :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  map_id        :bigint           not null
#
# Indexes
#
#  index_locations_on_map_id  (map_id)
#
# Foreign Keys
#
#  fk_rails_...  (map_id => maps.id)
#
FactoryBot.define do
  factory :location do
    name { 'Mapzy HQ' }
    description { 'The coolest place to be' }
    address_line1 { 'Hohlstrasse 117' }
    city { 'Zürich' }
    zip_code { '8004' }
    country_code { 'CH' }
    latitude { 12.222211 }
    longitude { 8.433332 }
    association :map
  end
end
