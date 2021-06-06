# frozen_string_literal: true

module Dashboard
  class LocationsController < DashboardController
    def new; end

    def create; end

    def show
      @location = Location.find(params[:id])
    end
  end
end
