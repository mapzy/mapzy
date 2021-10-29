# frozen_string_literal: true

class EmailWorker
  include Sidekiq::Worker

  def perform(email_type, user_id)
    user = User.find(user_id)
    return unless user.account.trial?
    
    case email_type
    when 'reminder_email1'
      AccountMailer.with(email: user.email).reminder_email1.deliver_later
    when 'reminder_email2'
      AccountMailer.with(email: user.email).reminder_email2.deliver_later
    when 'account_inactivated_email'
      AccountMailer.with(email: user.email).account_inactivated_email.deliver_later
    end
  end
end
