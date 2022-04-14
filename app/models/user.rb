# frozen_string_literal: true

# == Schema Information
#
# Table name: users
#
#  id                     :bigint           not null, primary key
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
# Indexes
#
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#
class User < ApplicationRecord
  include Hashid::Rails

  has_many :maps, dependent: :destroy
  has_one :account, dependent: :destroy
  has_one :map, dependent: :destroy

  # Active devise modules below. Other available modules:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :email, presence: true, uniqueness: { case_sensitive: false }

  # Create a default map for the user
  # @return [Map]
  def create_default_map
    Map.create(user_id: id, name: "Default")
  end

  # Find or create a default map for the user
  # @return [Map]
  def find_or_create_default_map
    if (default_map = maps.first)
      default_map
    else
      create_default_map
    end
  end

  def create_account
    Account.create(user: self)
  end
end
