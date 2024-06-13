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
class Map < ApplicationRecord
  include Hashid::Rails

  belongs_to :user
  has_many :locations, dependent: :destroy
  has_many :payload_dumps, class_name: "Sync::PayloadDump", dependent: :destroy
  has_one :api_key, dependent: :destroy


  validates :custom_color, presence: true
  validates :custom_accent_color, presence: true

  after_create :create_api_key

  def create_api_key
    api_key || ApiKey.create(map: self)
  end
end
