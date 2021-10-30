# frozen_string_literal: true

# == Schema Information
#
# Table name: users
#
#  id                     :bigint           not null, primary key
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  name                   :string
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
  include Sidekiq::Worker

  has_many :maps, dependent: :destroy
  has_one :account, dependent: :destroy

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

  def setup_email_workers
    EmailWorker.perform_at(7.days.from_now, "reminder_email1", id)
    EmailWorker.perform_at(13.days.from_now, "reminder_email2", id)
    EmailWorker.perform_at(14.days.from_now, "account_inactivated_email", id)
    AccountWorker.perform_at(14.days.from_now, id)
  end

  def send_welcome_email
    AccountMailer.with(email: email).welcome_email.deliver_later
  end
end
