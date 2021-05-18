# frozen_string_literal: true

class User < ApplicationRecord
  has_many :maps

  # Active devise modules below. Other available modules:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :email, presence: true, uniqueness: { case_sensitive: false }
  validates :name, presence: true

  # Create a default map for the user
  # @return [Map]
  def create_default_map
    Map.create(user_id: id, name: 'Default')
  end

  # Find or create a default map for the user
  # @return [Map]
  def find_or_create_default_map
    if default_map = maps.first
      default_map
    else
      create_default_map
    end
  end
end
