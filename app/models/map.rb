# frozen_string_literal: true

# == Schema Information
#
# Table name: maps
#
#  id         :bigint           not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :bigint           not null
#
# Indexes
#
#  index_maps_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
class Map < ApplicationRecord
  include Hashid::Rails

  belongs_to :user
  has_many :locations, dependent: :destroy

  # Default bounds are set to Europe
  DEFAULT_BOUNDS = [[-30, 25], [60, 75]].freeze

  # Define the geographical limits in which the map can be shown fully, given its locations
  #
  # @return [Array] Containing the bottom-right (west, south) & top-left (east, north) limits
  def bounds
    return DEFAULT_BOUNDS if markers[:features].blank?

    lats = markers[:features].map { |f| f[:geometry][:coordinates][1] }
    longs = markers[:features].map { |f| f[:geometry][:coordinates][0] }

    west, east = longs.minmax
    south, north = lats.minmax

    [[west, south], [east, north]]
  end

  # Markers for every location of the map, using GeoJson format
  #
  # @return [Hash] GeoJson format
  def markers
    @markers ||= LocationServices::GeoJson
                 .new(locations)
                 .convert_to_geo_json_hash
  end
end
