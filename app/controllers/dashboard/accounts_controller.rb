# frozen_string_literal: true

module Dashboard
  class AccountsController < DashboardController
    def settings
      unless current_user.account.valid_state?
        flash[:alert] = flash_alert_text
        return
      end

      return if current_user.account.trial? || current_user.account.inactive?

      customer = retrieve_stripe_customer

      return unless customer.subscriptions.data.first

      product_id = price_id(customer)
      @product = Stripe::Product.retrieve(product_id)
      @cancel_at = format_cancel_time(customer.subscriptions.data.first.cancel_at)
    end

    private

    def flash_alert_text
      "There is something wrong with your account. Please contact us at bonjour@mapzy.io"
    end

    def format_cancel_time(unix_time)
      return unless unix_time

      Time.at(unix_time).utc.to_datetime.strftime("%b %-d, %Y")
    end

    def price_id(stripe_customer)
      stripe_customer.subscriptions&.data&.first&.items&.data&.first&.price&.product
    end

    def retrieve_stripe_customer
      Stripe::Customer.retrieve(
        id: current_user.account.stripe_customer_id,
        expand: ["subscriptions"]
      )
    end
  end
end
