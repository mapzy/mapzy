# frozen_string_literal: true

module Users
  class RegistrationsController < Devise::RegistrationsController
    before_action :configure_sign_up_params, only: [:create]
    before_action :configure_account_update_params, only: [:update]

    def create
      super do |resource|
        if resource.valid?
          resource.create_account
          resource.setup_email_workers
          resource.send_welcome_email
        end
      end
    end

    # Add extra sign up params here
    def configure_sign_up_params
      devise_parameter_sanitizer.permit(:sign_up, keys: [:name])
    end

    # Add extra account update params here
    def configure_account_update_params
      devise_parameter_sanitizer.permit(:account_update, keys: %i[name email])
    end

    # Redirect after sign up
    def after_sign_up_path_for(_resource)
      authenticated_root_url_path
    end

    # Redirect after updating account
    def after_update_path_for(_resource)
      flash[:notice] = "Your account was updated successfully."
      dashboard_account_settings_path
    end

    private

    def remove_notice
      flash.discard(:notice)
    end
  end
end
