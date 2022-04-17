# frozen_string_literal: true

module Dashboard
  class MapsController < DashboardController
    include Trackable
    include Cloud::TrialNotifiable
    include Cloud::InactiveNotifiable

    after_action -> { track_event("Viewed Dash Map") }, only: %i[show]

    def show
      @map = Map.find(params[:id])
      @ask_location_permission = false
    end

    def index
      # Currently an user can have a single map
      # Thus, we redirect the user to her default map
      redirect_to dashboard_map_path(current_user.find_or_create_default_map)
    end
  end
end
