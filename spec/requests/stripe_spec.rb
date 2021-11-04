# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Stripe", type: :request do
  let(:account) { create(:account, stripe_customer_id: "abc1") }
  let(:user) { create(:user, account: account) }

  before do
    StripeMock.start
    stub_const("ENV", ENV.to_hash.merge("STRIPE_ENDPOINT_SECRET" => "fake_secret"))
  end

  after { StripeMock.stop }

  describe "POST webhooks" do
    context "with customer cancels subscription for end of billing cycle" do
      before do
        account.update(status: "active")
        event = customer_subscription_updated(true, account.stripe_customer_id)
        post stripe_webhooks_path, params: event, headers: stripe_headers(event), as: :json
      end

      it "sets account.status to 'canceled'" do
        expect(Account.find(account.id).status).to eq("canceled")
      end
    end

    context "with subscription canceled at the end of billing cycle" do
      before do
        event = customer_subscription_deleted(account.stripe_customer_id)
        post stripe_webhooks_path, params: event, headers: stripe_headers(event), as: :json
      end

      it "sets account.status to 'inactive'" do
        expect(Account.find(account.id).status).to eq("inactive")
      end
    end

    context "with customer re-activates canceled account before end of billing cycle" do
      before do
        event = customer_subscription_updated(false, account.stripe_customer_id)
        account.update(status: "canceled")
        post stripe_webhooks_path, params: event, headers: stripe_headers(event), as: :json
      end

      it "sets account.status back to 'active'" do
        expect(Account.find(account.id).status).to eq("active")
      end
    end
  end

  describe "GET success_callback" do
    before do
      customer = create_stripe_customer
      product = create_stripe_product
      price = create_stripe_price(product.id)
      session = create_stripe_checkout_session(customer.id, price.id)
      account.update(status: "trial", stripe_customer_id: customer.id)

      sign_in user
      get stripe_success_callback_path, params: { session_id: session.id }
    end

    it "sets account.status to 'active'" do
      expect(Account.find(account.id).status).to eq("active")
    end
  end
end
