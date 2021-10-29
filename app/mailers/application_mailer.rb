# frozen_string_literal: true

class ApplicationMailer < ActionMailer::Base
  default from: 'bonjour@mapzy.io'
  layout 'mailer'
end
