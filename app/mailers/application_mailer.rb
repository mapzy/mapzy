# frozen_string_literal: true

class ApplicationMailer < ActionMailer::Base
  default from: email_address_with_name("bonjour@mapzy.io", "Mapzy")
  layout "mailer"
end
