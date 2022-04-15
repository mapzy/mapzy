# frozen_string_literal: true

module SharedViewsHelper
  def shared_locations_path
    if controller.controller_path.include?('dashboard')
      send :dashboard_map_locations_path, @map
    else
      send :locations_path
    end
  end
end