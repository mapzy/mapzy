# frozen_string_literal: true

module SharedViewsHelper
  # rubocop:disable Rails/HelperInstanceVariable
  def shared_locations_path
    if controller.controller_path.include?("dashboard")
      send :dashboard_map_locations_path, @map
    else
      send :map_locations_path, @map
    end
  end
  # rubocop:enable Rails/HelperInstanceVariable
end
