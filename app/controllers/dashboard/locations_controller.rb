# frozen_string_literal: true

module Dashboard
  class LocationsController < DashboardController
    skip_authorize_resource only: [:new]

    before_action :set_map

    def new
      @location = @map.locations.new
      authorize! :new, @location

      @bounds = @map.bounds
    end

    def create
      @location = @map.locations.build(location_params)

      if @location.save
        redirect_to dashboard_map_path(@map)
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
    end

    def update
      @location = @map.locations.find(params[:id])

      if @location.update(location_params)
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
            .permit(:name, :description, :address, :zip_code, :city,
                    :state, :country, :latitude, :longitude)
    end
  end
end
