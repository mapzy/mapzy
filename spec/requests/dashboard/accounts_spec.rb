# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Accounts", type: :request do
  let(:user) { create(:user, account: create(:account), map: create(:map)) }

  before do
    @mapzy_cloud_env_before = ENV["MAPZY_CLOUD"]
    ENV["MAPZY_CLOUD"] = "true" 
    sign_in user
  end

  after do
    ENV["MAPZY_CLOUD"] = @mapzy_cloud_env_before
  end

  describe "GET /dashboard/settings" do
    context "with new (trial) account" do
      before do
        get dashboard_account_settings_path
      end

      it "responds with a HTTP 200" do
        expect(response).to have_http_status(:ok)
      end

      it "contains correct text" do
        expect(response.body).to include("Your trial ends on")
      end

      it "contains the start subscription link" do
        expect(response.body).to include('href="/stripe/checkout_session?sub=mini"')
      end
    end

    # context "with active account" do
    #   let(:stripe_helper) { StripeMock.create_test_helper }

    #   before do
    #     StripeMock.start
    #     stripe_customer = create_stripe_customer
    #     product = create_stripe_product
    #     create_stripe_checkout_session(stripe_customer.id, create_stripe_price(product.id))
    #     user.account.stripe_customer_id = stripe_customer.id
    #     user.account.status = "active"
    #     get dashboard_account_settings_path
    #   end

    #   after do
    #     StripeMock.stop
    #   end

    #   # skip while waiting for new version of stripe-ruby-mock
    #   xit "responds with a HTTP 200" do
    #     expect(response).to have_http_status(:ok)
    #   end

    #   # skip while waiting for new version of stripe-ruby-mock
    #   xit "contains the start subscription link" do
    #     expect(response.body).to include('href="/stripe/checkout_session?sub=mini"')
    #   end
    # end

    context "with canceled account" do
      before do
        user.account.status = "canceled"
        get dashboard_account_settings_path
      end

      # skip while waiting for new version of stripe-ruby-mock
      xit "responds with a HTTP 200" do
        expect(response).to have_http_status(:ok)
      end
    end

    context "with inactive account" do
      before do
        user.account.status = "inactive"
        get dashboard_account_settings_path
      end

      it "responds with a HTTP 200" do
        expect(response).to have_http_status(:ok)
      end

      it "contains correct text" do
        expect(response.body).to include("Your subscription is currently inactive")
      end

      it "contains the start subscription link" do
        expect(response.body).to include('href="/stripe/checkout_session?sub=mini"')
      end
    end
  end
end
