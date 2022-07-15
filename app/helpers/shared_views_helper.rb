# frozen_string_literal: true

module SharedViewsHelper
  def shared_locations_path(map_id)
    if controller.controller_path.include?("dashboard")
      send :dashboard_map_locations_path, map_id
    else
      send :map_locations_path, map_id
    end
  end

  def sync_mode_path(initial_path, sync_mode)
    return initial_path unless sync_mode

    "#"
  end
end
