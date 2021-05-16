# frozen_string_literal: true

# == Schema Information
#
# Table name: locations
#
#  id            :bigint           not null, primary key
#  addres_line_1 :string
#  city          :string
#  country_code  :string
#  description   :text
#  lat           :decimal(15, 10)
#  long          :decimal(15, 10)
#  name          :string
#  street_number :string
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
class Location < ApplicationRecord
  belongs_to :map
end
