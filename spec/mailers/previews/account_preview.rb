# frozen_string_literal: true

# Preview all emails at http://localhost:3000/rails/mailers/account
class AccountPreview < ActionMailer::Preview
  def welcome_email
    AccountMailer.with(email: User.first.email).welcome_email
  end

  def reminder_email1
    AccountMailer.with(email: User.first.email).reminder_email1
  end

  def reminder_email2
    AccountMailer.with(email: User.first.email).reminder_email2
  end

  def account_inactivated_email
    AccountMailer.with(email: User.first.email).account_inactivated_email
  end
end
