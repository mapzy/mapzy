# frozen_string_literal: true

module Dashboard
  class MapsController < DashboardController
    include TrialNotifiable
    include InactiveNotifiable

    after_action :track_viewed_map_event, only: %i[show]

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

    private

    def track_viewed_map_event
      FuguWorker.perform_async("Viewed Dash Map")
    end
  end
end
