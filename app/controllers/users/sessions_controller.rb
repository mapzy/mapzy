# frozen_string_literal: true

module Users
  class SessionsController < Devise::SessionsController
    after_action :remove_notice, only: [:destroy, :create]

    # Redirect after sign in
    def after_sign_in_path_for(resource)
      maps_path
    end

    private

    def remove_notice
      flash.discard(:notice)
    end
  end
end
