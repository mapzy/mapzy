# frozen_string_literal: true

module Dashboard
  class LocationsController < DashboardController
    include Trackable

    skip_authorize_resource only: %i[new create]

    before_action :set_map
    before_action :set_bounds, only: %i[new edit create update]
    before_action :set_address, only: %i[new edit create update]
    before_action :set_opening_times, only: %i[new edit create update]

    after_action -> { track_event("Viewed Add Location") }, only: %i[new]
    after_action -> { track_event("Added Location") }, only: %i[create]
    after_action -> { track_event("Updated Location") }, only: %i[update]
    after_action -> { track_event("Viewed Dash Location") }, only: %i[show]

    def show
      @location = @map.locations.find(params[:id])
    end

    def index
      @locations = @map.locations
    end

    def new
      @location = @map.locations.new
      authorize! :new, @location
    end

    def create
      @location = @map.locations.build(location_params)
      authorize! :create, @location

      if @location.save
        redirect_to dashboard_map_path(@map)
        flash[:notice] = "Yippie! The location #{@location.name} has been successfully created."
      else
        flash.now[:error] = @location.errors.full_messages
        render :new, status: :unprocessable_entity
      end
    end

    def edit
      @location = @map.locations.find(params[:id])
    end

    def update
      if @location.update(location_params)
        flash[:notice] = "The location #{@location.name} has been successfully updated."
        redirect_to dashboard_map_path(@map)
      else
        flash.now[:error] = @location.errors.full_messages
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      @location = @map.locations.find(params[:id])
      @location.destroy

      redirect_to dashboard_map_path(@map), notice: \
        "The location #{@location.name} has been successfully deleted."
    end

    private

    def set_map
      @map = Map.find(params[:map_id])
    end

    def set_bounds
      @bounds = @map.bounds
    end

    def set_address
      @address = @location.address
    end

    def set_opening_times
      @opening_times = @location.opening_times.presence || @location.opening_times.build_default
    end

    def location_params
      params.require(:location)
            .permit(:name, :description, :address, :latitude, :longitude,
                    opening_times_attributes: \
                      %i[id location_id day opens_at closes_at closed open_24h])
    end
  end
end
