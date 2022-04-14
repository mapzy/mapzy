# frozen_string_literal: true

module Cloud
  module RegistrationWorkable
    extend ActiveSupport::Concern

    include Sidekiq::Worker

    def send_welcome_email(email)
      return unless mapzy_cloud?

      AccountMailer.with(email: email).welcome_email.deliver_later
    end

    def setup_registration_workers(user_id)
      return unless mapzy_cloud?

      EmailWorker.perform_at(7.days.from_now, "reminder_email1", user_id)
      EmailWorker.perform_at(13.days.from_now, "reminder_email2", user_id)
      EmailWorker.perform_at(14.days.from_now, "account_inactivated_email", user_id)
      AccountWorker.perform_at(14.days.from_now, user_id)
    end
  end
end
