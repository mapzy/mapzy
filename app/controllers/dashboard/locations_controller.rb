# frozen_string_literal: true

module Dashboard
  class LocationsController < DashboardController
    include Trackable

    before_action :set_map
    before_action :set_location, only: %i[show edit update destroy]
    before_action :redirect_to_map, only: %i[new edit], if: -> { @map.sync_mode }

    after_action -> { track_event("Viewed Add Location") }, only: %i[new]
    after_action -> { track_event("Added Location") }, only: %i[create]
    after_action -> { track_event("Updated Location") }, only: %i[update]
    after_action -> { track_event("Viewed Dash Location") }, only: %i[show]

    def show; end

    def index
      @locations = @map.locations.order_by_unfinished
    end

    def new
      @location = @map.locations.new
      @opening_times = @location.opening_times.build_default
    end

    def create
      @location = @map.locations.build(location_params)

      if @location.save
        redirect_to dashboard_map_path(@map)
        flash[:notice] = "Yippie! The location #{@location.name} has been successfully created."
      else
        flash.now[:error] = @location.errors.full_messages
        render :new, status: :unprocessable_content
      end
    end

    def edit
      @address = @location.address
      @opening_times = @location.opening_times.order(:day).presence ||
                       @location.opening_times.build_default
    end

    def update
      if @location.update(location_params)
        flash[:notice] = "The location #{@location.name} has been successfully updated."
        redirect_to dashboard_map_path(@map)
      else
        flash.now[:error] = @location.errors.full_messages
        @address = @location.address
        render :edit, status: :unprocessable_content
      end
    end

    def destroy
      @location.destroy

      redirect_to dashboard_map_path(@map), notice: \
        "The location #{@location.name} has been successfully deleted."
    end

    private

    def set_map
      @map = Map.find(params[:map_id])
    end

    def set_location
      @location = @map.locations.find(params[:id])
    end

    def redirect_to_map
      redirect_to dashboard_map_path(@map)
    end

    def location_params
      params.require(:location)
            .permit(:name, :description, :address, :latitude, :longitude,
                    opening_times_attributes: \
                      %i[id location_id day opens_at closes_at closed open_24h _destroy])
    end
  end
end
