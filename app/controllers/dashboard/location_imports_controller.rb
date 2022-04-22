# frozen_string_literal: true

module Dashboard
  class LocationImportsController < DashboardController
    before_action :set_map
    before_action :init_spreadsheet_data, only: %i[new]
    before_action :init_errors, only: %i[new]

    def new; end

    def create
      @spreadsheet_data = JSON.parse(params[:spreadsheet_data])
      @errors = LocationImport.validate_csv(@map, @spreadsheet_data)
      puts @errors

      if @errors.present?
        flash.now[:error] = "There were some errors. Please check the highlighted rows and "\
                            "see below the spreadsheet for detailed error messages."
        @row_offset = LocationImport::ROW_OFFSET
        render :new, status: :unprocessable_entity
      else
        # kick off async job and redirect to map view with flash
        flash.now[:success] = "Great! We're importing your locations. "\
                              "We'll send you an email when it's done. "\
                              "You don't need to keep this window open."
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
