# frozen_string_literal: true

class User < ApplicationRecord
  has_many :maps

  # Active devise modules below. Other available modules:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :email, presence: true, uniqueness: { case_sensitive: false }
  validates :name, presence: true
end
