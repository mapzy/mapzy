# frozen_string_literal: true

class ApplicationController < ActionController::Base
  def mapzy_cloud?
    ENV["MAPZY_CLOUD"] == "true"
  end
end
