# frozen_string_literal: true

module ApplicationHelper
  def mapzy_cloud?
    ENV["MAPZY_CLOUD"] == "true"
  end

  def allow_registration?
    ENV["ALLOW_REGISTRATION"] == "true"
  end
end
