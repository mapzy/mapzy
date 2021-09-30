# frozen_string_literal: true

class StripeController < ApplicationController
  skip_before_action :verify_authenticity_token, only: %i[webhooks]
  before_action :verify_webhook, only: %i[webhooks]

  def checkout_session
    session = Stripe::Checkout::Session.create(checkout_session_args)
    redirect_to session.url
  rescue StandardError
    flash[:alert] = 'Something went wrong. Please try again or contact us at bonjour@mapzy.io'
    redirect_to dashboard_account_settings_url
  end

  def success_callback
    session = Stripe::Checkout::Session.retrieve(params[:session_id])
    @customer = Stripe::Customer.retrieve(session.customer)

    update_user_account

    flash[:notice] = 'Subscription successful! Enjoy Mapzy!'
    redirect_to dashboard_account_settings_url
  rescue StandardError
    flash[:alert] = 'Something went wrong. Please try again or contact us at bonjour@mapzy.io'
    redirect_to dashboard_account_settings_url
  end

  def customer_portal
    customer_portal_session = Stripe::BillingPortal::Session.create(
      {
        customer: current_user.account.stripe_customer_id,
        return_url: dashboard_account_settings_url
      }
    )
    redirect_to customer_portal_session.url
  rescue StandardError
    flash[:alert] = 'Something went wrong. Please try again or contact us at bonjour@mapzy.io'
    redirect_to dashboard_account_settings_url
  end

  def webhooks
    # cases:
    # - customer cancels subscription for the end of the billing cycle (customer.subscription.updated)
    # - subscription is canceled at the end of billing cycle (customer.subscription.deleted)
    # - customer re-activates canceled account before end of billing cycle (customer.subscription.updated)

    case params[:type]
    when 'customer.subscription.updated'
      handle_subscription_updated
    when 'customer.subscription.deleted'
      handle_subscription_deleted
    else
      head :ok
    end
  end

  def verify_webhook
    Stripe::Webhook.construct_event(
      request.raw_post, request.env['HTTP_STRIPE_SIGNATURE'], ENV['STRIPE_ENDPOINT_SECRET']
    )
  rescue StandardError
    head :not_found
  end

  private

  def handle_subscription_updated
    set_account
    if sub_cancel_at_period_end && !@account.canceled?
      @account.update(status: 'canceled')
    elsif !sub_cancel_at_period_end
      @account.update(status: 'active')
    end

    head :ok
  rescue StandardError
    head :internal_server_error
  end

  def handle_subscription_deleted
    set_account
    @account.update(status: 'inactive') unless @account.inactive?
    head :ok
  rescue StandardError
    head :internal_server_error
  end

  def sub_cancel_at_period_end
    params[:data][:object][:cancel_at_period_end]
  end

  def sub_customer_id
    params[:data][:object][:customer]
  end

  def set_account
    @account = Account.find_by(stripe_customer_id: sub_customer_id)
  end

  def update_user_account
    Account.find_by(user: current_user)
           .update!(stripe_customer_id: @customer.id, status: 'active')
  end

  def checkout_session_args
    {
      payment_method_types: ['card'],
      customer_email: current_user.account.stripe_customer_id ? nil : current_user.email,
      customer: current_user.account.stripe_customer_id,
      line_items: [{
        price: price_id,
        quantity: 1
      }],
      mode: 'subscription',
      success_url: "#{stripe_success_callback_url}?session_id={CHECKOUT_SESSION_ID}",
      cancel_url: dashboard_account_settings_url
    }
  end

  def price_id
    case params[:sub]
    when 'mini'
      ENV['STRIPE_MINI_PRICE_ID']
    when 'medium'
      ENV['STRIPE_MEDIUM_PRICE_ID']
    when 'maxi'
      ENV['STRIPE_MAXI_PRICE_ID']
    end
  end
end
