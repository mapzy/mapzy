# frozen_string_literal: true

module Dashboard
  class AccountsController < DashboardController
    before_action :validate_account, only: [:settings]

    def settings
      @product = Stripe::Product.retrieve(product)
      @cancel_at = format_cancel_time(subscription.cancel_at)
    end

    private

    def validate_account
      return if current_user.account.valid_state? && subcription.present? && product.present?

      flash[:alert] = flash_alert_text
      throw(:abort)
    end

    def flash_alert_text
      "There is something wrong with your account. Please contact us at bonjour@mapzy.io"
    end

    def format_cancel_time(unix_time)
      return unless unix_time

      Time.at(unix_time).utc.to_datetime.strftime("%b %-d, %Y")
    end

    def product
      @product ||= subscription.items&.data&.first&.price&.product
    end

    def subscription
      @subcription ||= stripe_customer.subscriptions&.data&.first
    end

    def stripe_customer
      @stripe_customer ||= Stripe::Customer.retrieve(
        id: current_user.account.stripe_customer_id,
        expand: ["subscriptions"]
      )
    end
  end
end
