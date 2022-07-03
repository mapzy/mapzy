# frozen_string_literal: true

# == Schema Information
#
# Table name: api_keys
#
#  id         :bigint           not null, primary key
#  key_value  :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  map_id     :bigint           not null
#
# Indexes
#
#  index_api_keys_on_key_value  (key_value) UNIQUE
#  index_api_keys_on_map_id     (map_id)
#
# Foreign Keys
#
#  fk_rails_...  (map_id => maps.id)
#
class ApiKey < ApplicationRecord
  belongs_to :map

  validates :key_value, presence: true, uniqueness: true

  before_validation :generate_key, on: :create

  def generate_key
    self.key_value ||= SecureRandom.hex
  end
end
