# frozen_string_literal: true

module Users
  class PasswordsController < Devise::PasswordsController
    def create
      super do |resource|
        flash.now[:alert] = resource.errors.full_messages.join(", ") if resource.errors.present?
      end
    end

    def update
      super do |resource|
        flash.now[:alert] = resource.errors.full_messages.join(", ") if resource.errors.present?
      end
    end
  end
end
