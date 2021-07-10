# frozen_string_literal: true

module Dashboard
  class LocationsController < DashboardController
    before_action :set_map

    def new; end

    def create; end

    def show
      @location = Location.find(params[:id])
    end

    private

    def set_map
      @map = Map.find(params[:map_id])
    end
  end
end
