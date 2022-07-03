# frozen_string_literal: true

module Dashboard
  class MapsController < DashboardController
    include Trackable
    include Cloud::TrialNotifiable
    include Cloud::InactiveNotifiable

    before_action :set_map, only: %i[show update]
    after_action -> { track_event("Viewed Dash Map") }, only: %i[show]

    def show
      @locations = @map.locations.geocoding_success
      @ask_location_permission = false
    end

    def index
      # Currently an user can have a single map
      # Thus, we redirect the user to her default map
      redirect_to dashboard_map_path(current_user.find_or_create_default_map)
    end

    def update
      if @map.update(map_params)
        head :ok, content_type: "text/html"
      else
        # rubocop:disable Rails/OutputSafety
        render html: %(
          <turbo-frame id="sync_mode">
            Something went wrong: #{@map.errors.full_messages}<br>
            Please try again.
          </turbo-frame>
        ).html_safe
        # rubocop:enable Rails/OutputSafety
      end
    end

    private

    def set_map
      @map = Map.find(params[:id])
    end

    def map_params
      params.require(:map).permit(:id, :sync_mode)
    end
  end
end
