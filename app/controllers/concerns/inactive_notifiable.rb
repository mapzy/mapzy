# frozen_string_literal: true

module InactiveNotifiable
  extend ActiveSupport::Concern

  included do
    before_action :show_inactive_warning, if: :account_inactive?, only: [:show]
  end

  private

  def show_inactive_warning
    flash[:alert] = %(
      Your account is currently inactive.
      If you want to continue using Mapzy, please make sure to subscribe to
      one of our <a href="#{dashboard_account_settings_url}">plans</a>.
    )
  end

  def account_inactive?
    current_user.account.inactive?
  end
end