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
require "rails_helper"

RSpec.describe ApiKey, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
