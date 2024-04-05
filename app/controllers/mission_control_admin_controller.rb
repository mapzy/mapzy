# frozen_string_literal: true

class MissionControlAdminController < ApplicationController
  # used by Mission Control to authenticate access to the jobs dashboard
    http_basic_authenticate_with name: ENV.fetch("MISSION_CONTROL_USERNAME"),
                                 password: ENV.fetch("MISSION_CONTROL_PASSWORD")
end
