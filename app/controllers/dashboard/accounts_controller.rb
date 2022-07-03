# frozen_string_literal: true

module Dashboard
  class AccountsController < DashboardController
    include Trackable
    include Cloud::Stripeable

    after_action -> { track_event("Viewed Account Settings") }, only: %i[settings]
    after_action -> { track_event("Viewed Embed Code") }, only: %i[embed]

    def settings
      @map = Map.find_by(user: current_user)

      return if current_user.account.trial? || current_user.account.inactive?
      return if stripe_customer.blank? || stripe_subscription.blank?

      @product = Stripe::Product.retrieve(stripe_product)
      @cancel_at = format_cancel_time(stripe_subscription.cancel_at)
    end

    def embed; end

    private

    def format_cancel_time(unix_time)
      return unless unix_time

      Time.at(unix_time).utc.to_datetime.strftime("%b %-d, %Y")
    end

    def account
      @account ||= current_user.account
    end
  end
end
