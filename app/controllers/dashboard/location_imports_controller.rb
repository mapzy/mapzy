# frozen_string_literal: true

module Dashboard
  class LocationImportsController < DashboardController
    def new
      @map = Map.find(params[:map_id])
    end

    def create
      puts JSON.parse(params[:import_data])[0]
    end
  end
end
