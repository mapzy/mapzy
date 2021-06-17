# frozen_string_literal: true

module Dashboard
  class MapsController < DashboardController
    include MapsControllable
   
    load_and_authorize_resource

    def index
      # Currently an user can have a single map
      # Thus, we redirect the user to her default map
      redirect_to map_path(current_user.find_or_create_default_map)
    end
  end
end
