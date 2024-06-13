# frozen_string_literal: true

# == Schema Information
#
# Table name: maps
#
#  id                  :bigint           not null, primary key
#  custom_accent_color :string           default("#f99b46"), not null
#  custom_color        :string           default("#e74d67"), not null
#  name                :string
#  sync_mode           :boolean          default(FALSE), not null
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  user_id             :bigint           not null
#
# Indexes
#
#  index_maps_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
require "rails_helper"

RSpec.describe Map, type: :model do
  describe "associations" do
    it { is_expected.to belong_to(:user) }
    it { is_expected.to have_many(:locations) }
  end
end
