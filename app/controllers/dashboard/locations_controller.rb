# frozen_string_literal: true

module Dashboard
  class LocationsController < DashboardController
    before_action :set_map

    def create
      @location = @map.locations.build(location_params)

      if @location.save
        redirect_to dashboard_map_path(@map)
      else
        flash[:error] = @location.errors.full_messages
        render 'new', status: :unprocessable_entity
      end
    end

    def edit
      @location = @map.locations.find(params[:id])
    end

    def show
      @location = Location.find(params[:id])
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
