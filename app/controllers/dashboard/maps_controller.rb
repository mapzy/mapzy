# frozen_string_literal: true

module Dashboard
  class MapsController < DashboardController
    def show
      @map = Map.find(params[:id])
      @bounds = @map.bounds
      @markers_json = @map.markers.to_json
      @location_base_url = "/dashboard/maps/#{@map.id}/locations/"
    end

    def index
      # Currently an user can have a single map
      # Thus, we redirect the user to her default map
      redirect_to dashboard_map_path(current_user.find_or_create_default_map)
    end
  end
end
