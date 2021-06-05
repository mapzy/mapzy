# frozen_string_literal: true

class DashboardController < ApplicationController
  # Authentication with Devise
  before_action :authenticate_user!

  # Authorization with Cancancan
  # See app/models/ability.rb
  load_and_authorize_resource
end
