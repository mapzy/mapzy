# frozen_string_literal: true

module Cloud
  module RegistrationWorkable
    extend ActiveSupport::Concern

    def send_welcome_email(email)
      return unless mapzy_cloud?

      AccountMailer.with(email: email).welcome_email.deliver_later
    end

    def setup_registration_workers(user_id)
      return unless mapzy_cloud?
      EmailJob.set(wait_until: 7.days.from_now).perform_later("reminder_email1", user_id)
      EmailJob.set(wait_until: 13.days.from_now).perform_later("reminder_email2", user_id)
      EmailJob.set(wait_until: 14.days.from_now).perform_later("account_inactivated_email", user_id)
      AccountJob.set(wait_until: 14.days.from_now).perform_later(user_id)
    end
  end
end
