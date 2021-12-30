# frozen_string_literal: true

module TrialNotifiable
  extend ActiveSupport::Concern

  included do
    before_action :show_trial_reminder, if: :reminder_time?, only: [:show]
  end

  private

  def show_trial_reminder
    set_cookie

    flash.now[:notice] = %(
      Thanks for trying out Mapzy.
      Your trial ends on
      #{current_user.account.trial_end_date.strftime('%b %-d, %Y')}.
      Make sure to subscribe to one of our
      <a href="#{dashboard_account_settings_url}">plans</a> before that.
    )
  end

  def set_cookie
    cookies[cookie_key] = {
      expires: 1.day.from_now
    }
  end

  def reminder_time?
    current_user.account.trial? && cookies[cookie_key].blank?
  end

  def cookie_key
    "trial_notifier_#{current_user.hashid}".to_sym
  end
end
