# frozen_string_literal: true

module Dashboard
  class LocationsController < DashboardController
    skip_authorize_resource only: %i[new create]

    before_action :set_map

    def new
      @location = @map.locations.new
      authorize! :new, @location

      @bounds = @map.bounds
    end

    def create
      @location = @map.locations.build(location_params)
      authorize! :create, @location

      if @location.save
        redirect_to dashboard_map_path(@map)
        flash[:notice] = "Yippie! The location #{@location.name} has been successfully created."
      else
        flash[:error] = @location.errors.full_messages
        render action: :new, status: :unprocessable_entity
      end
    end

    def show
      @location = @map.locations.find(params[:id])
    end

    def edit
      @bounds = @map.bounds
      @location = @map.locations.find(params[:id])
      @address = @location.address
    end

    def update
      if @location.update(location_params)
        flash[:notice] = "The location #{@location.name} has been successfully updated."
        redirect_to dashboard_map_path(@map)
      else
        flash[:error] = @location.errors.full_messages
        render action: :edit, status: :unprocessable_entity
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

    def location_params
      params.require(:location)
            .permit(:name, :description, :address, :latitude, :longitude)
    end
  end
end
