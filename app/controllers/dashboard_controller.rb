# frozen_string_literal: true

class DashboardController < ApplicationController
  # Authentication with Devise
  before_action :authenticate_user!

  def render_turbo_stream_flash_message(type, message, action = :update)
    case action
    when :update
      turbo_stream.update(
        :flash,
        partial: "shared/flash_#{type}",
        locals: { message: message }
      )
    when :prepend
      turbo_stream.prepend(
        :flash,
        partial: "shared/flash_#{type}",
        locals: { message: message }
      )
    end
  end

  def render_turbo_stream_clear_flash
    turbo_stream.update(:flash, "")
  end
end
