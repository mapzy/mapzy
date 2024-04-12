# frozen_string_literal: true

module Dashboard
  class LocationImportsController < DashboardController
    before_action :set_map
    before_action :init_spreadsheet_data, only: %i[new]
    before_action :init_errors, only: %i[new]

    def new; end

    def create
      @spreadsheet_data = JSON.parse(params[:spreadsheet_data])
      location_import = LocationImport.new(@map, @spreadsheet_data)

      if location_import.errors.present?
        @errors = location_import.errors
        @row_offset = LocationImport::ROW_OFFSET
        render :new, status: :unprocessable_entity
      else
        # bulk insert all locations to database
        result = location_import.insert_all
        if result.failed_instances.empty?
          # kick off async job and redirect to map view with flash
          BatchGeocodeJob.perform_later(@map.id)
          flash[:success] = "Great! We're importing your locations. "\
                                "We'll send you an email when it's done. "\
                                "You don't need to keep this window open."

          redirect_to dashboard_map_path(@map)
        else
          flash.now[:alert] = "We couldn't create your locations. "\
                              "Please try again or reach out to bonjour@mapzy.io"
          render :new, status: :unprocessable_entity
        end
      end
    end

    private

    def set_map
      @map = Map.find(params[:map_id])
    end

    def init_spreadsheet_data
      @spreadsheet_data = [
        [
          "Joe's Pasta Shop",
          "Fresh pasta based on Nonna's legendary recipe",
          "200 Kent Ave, Brooklyn, NY 11249, United States",
          "",
          "08:00", "18:00",     # monday
          "08:00", "18:00",     # tuesday
          "", "",               # wednesday
          "08:00", "18:00",     # thursday
          "24", "24",           # friday
          "08:00", "16:00",     # saturday
          "", ""                # sunday
        ], [], [], [], [], [], [], [], [], [] # empty rows
      ]
    end

    def init_errors
      @errors = {}
    end
  end
end
