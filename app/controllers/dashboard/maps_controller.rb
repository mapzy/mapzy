# frozen_string_literal: true

module Dashboard
  class MapsController < DashboardController
    include TrialNotifier
    include InactiveNotifier

    def show
      @map = Map.find(params[:id])
      @location_base_url = dashboard_map_locations_path(@map)
      @ask_location_permission = false
    end

    def index
      # Currently an user can have a single map
      # Thus, we redirect the user to her default map
      redirect_to dashboard_map_path(current_user.find_or_create_default_map)
    end
  end
end
