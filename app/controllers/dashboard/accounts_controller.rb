# frozen_string_literal: true

module Dashboard
  class AccountsController < DashboardController
    after_action :track_settings_event, only: %i[settings]
    after_action :track_embed_event, only: %i[embed]

    def settings
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

    def stripe_product
      @stripe_product ||= stripe_subscription.items&.data&.first&.price&.product
    end

    def stripe_subscription
      @stripe_subscription ||= stripe_customer.subscriptions&.data&.first
    end

    def stripe_customer
      @stripe_customer ||= Stripe::Customer.retrieve(
        id: current_user.account.stripe_customer_id,
        expand: ["subscriptions"]
      )
    end

    def track_settings_event
      FuguWorker.perform_async("Viewed Account Settings")
    end

    def track_embed_event
      FuguWorker.perform_async("Viewed Embed Code")
    end
  end
end
