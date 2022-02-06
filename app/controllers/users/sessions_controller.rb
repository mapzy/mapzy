# frozen_string_literal: true

module Users
  class SessionsController < Devise::SessionsController
    include Trackable

    after_action :remove_notice, only: %i[destroy create]
    after_action -> { track_event("Viewed Sign In") }, only: %i[new]

    def create
      super do |resource|
        if resource.errors.present?
          flash.now[:alert] =
            resource.errors.full_messages.join.call(", ")
        end
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
