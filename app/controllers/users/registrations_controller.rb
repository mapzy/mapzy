# frozen_string_literal: true

module Users
  class RegistrationsController < Devise::RegistrationsController
    before_action :configure_sign_up_params, only: [:create]
    before_action :configure_account_update_params, only: [:update]

    protected

    # Add extra sign up params here
    def configure_sign_up_params
      devise_parameter_sanitizer.permit(:sign_up, keys: [:name])
    end

    # Add extra account update params here
    def configure_account_update_params
      devise_parameter_sanitizer.permit(:account_update, keys: [:name])
    end

    # Redirect after sign up
    def after_sign_up_path_for(resource)
      maps_path
    end

    private

    def remove_notice
      flash.discard(:notice)
    end
  end
end
