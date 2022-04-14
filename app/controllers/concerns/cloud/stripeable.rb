# frozen_string_literal: true

module Cloud
  module Stripeable
    extend ActiveSupport::Concern

    private

    def stripe_product
      @stripe_product ||= stripe_subscription.items&.data&.first&.price&.product
    end

    def stripe_subscription
      @stripe_subscription ||= stripe_customer.subscriptions&.data&.first
    end

    def stripe_customer
      return unless mapzy_cloud?

      @stripe_customer ||= Stripe::Customer.retrieve(
        id: current_user.account.stripe_customer_id,
        expand: ["subscriptions"]
      )
    end
  end
end
