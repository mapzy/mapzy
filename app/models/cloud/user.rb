# frozen_string_literal: true

# This logic is used as part of our hosted offering of Mapzy (Mapzy Cloud)
module Cloud
  module User
    class CloudEmails
      include Sidekiq::Worker

      def initialize(user)
        @user = user
      end

      def setup_email_workers
        return unless ENV["MAPZY_CLOUD"] == "true"

        EmailWorker.perform_at(7.days.from_now, "reminder_email1", @user.id)
        EmailWorker.perform_at(13.days.from_now, "reminder_email2", @user.id)
        EmailWorker.perform_at(14.days.from_now, "account_inactivated_email", @user.id)
        AccountWorker.perform_at(14.days.from_now, @user.id)
      end

      def send_welcome_email
        return unless ENV["MAPZY_CLOUD"] == "true"

        AccountMailer.with(email: @user.email).welcome_email.deliver_later
      end
    end
  end
end
