# frozen_string_literal: true

class HealthCheckController < ApplicationController
  def up
    head :ok
  end
end  