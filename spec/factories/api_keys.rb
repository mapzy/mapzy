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
#  index_api_keys_on_map_id  (map_id)
#
# Foreign Keys
#
#  fk_rails_...  (map_id => maps.id)
#
FactoryBot.define do
  factory :api_key do
    key_value { "MyString" }
    map { nil }
  end
end
