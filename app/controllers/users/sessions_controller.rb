# frozen_string_literal: true

module Users
  class SessionsController < Devise::SessionsController
    after_action :remove_notice, only: %i[destroy create]

    def create
      super do |resource|
        flash.now[:alert] = resource.errors.full_messages.join.(", ") if resource.errors.present?
      end
    end

    def update
      super do |resource|
        flash.now[:alert] = resource.errors.full_messages.join(", ") if resource.errors.present?
      end
    end

    # Redirect after sign in
    def after_sign_in_path_for(_resource)
      authenticated_root_url_path
    end

    private

    def remove_notice
      flash.discard(:notice)
    end
  end
end
