# frozen_string_literal: true

class AccountMailer < ApplicationMailer
  def welcome_email
    mail(
      to: params[:email],
      subject: "Welcome to Mapzy 👋"
    )
  end

  def reminder_email1
    mail(
      to: params[:email],
      subject: "Your Mapzy trial ends in 7 days"
    )
  end

  def reminder_email2
    mail(
      to: params[:email],
      subject: "Your Mapzy trial ends tomorrow"
    )
  end

  def account_inactivated_email
    mail(
      to: params[:email],
      subject: "Your Mapzy trial is over"
    )
  end
end
