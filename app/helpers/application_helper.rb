# frozen_string_literal: true

module ApplicationHelper
  def allow_registration?
    ENV["ALLOW_REGISTRATION"] == "true"
  end
end
