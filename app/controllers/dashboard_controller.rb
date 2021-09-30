# frozen_string_literal: true

class DashboardController < ApplicationController
  # Authentication with Devise
  before_action :authenticate_user!
  before_action :show_trial_reminder

  # Authorization with Cancancan
  # See models/ability.rb
  load_and_authorize_resource

  private

  def show_trial_reminder
    return unless current_user.account.trial?
    flash[:notice] = trial_reminder_text
  end

  def trial_reminder_text
    %Q(
      Thanks for trying out Mapzy.
      Your trial ends on
      #{current_user.account.trial_end_date.strftime('%b %-d, %Y')}
      and your map will be set to inactive. Make sure to subscribe to
      one of our <a href="#{dashboard_account_settings_url}">plans</a> before that.
    )
  end
end
