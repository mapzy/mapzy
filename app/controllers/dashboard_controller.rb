# frozen_string_literal: true

class DashboardController < ApplicationController
  # Authentication with Devise
  before_action :authenticate_user!

  # Authorization with Cancancan
  # See models/ability.rb
  load_and_authorize_resource

  private

  def show_trial_reminder
    return unless current_user.account.trial?
    return if cookies[:trial_reminder_shown]

    cookies[:trial_reminder_shown] = {
      value: "true",
      expires: 1.day
    }

    flash.now[:notice] = trial_reminder_text
  end

  def trial_reminder_text
    %(
      Thanks for trying out Mapzy.
      Your trial ends on
      #{current_user.account.trial_end_date.strftime('%b %-d, %Y')}. Make sure to subscribe to
      one of our <a class="text-mapzy-orange hover:underline" href="#{dashboard_account_settings_url}">plans</a> before that.
    )
  end
end
