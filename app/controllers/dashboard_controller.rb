# frozen_string_literal: true

class DashboardController < ApplicationController
  # Authentication with Devise
  before_action :authenticate_user!
end
