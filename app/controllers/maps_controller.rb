# frozen_string_literal: true

class MapsController < ApplicationController
  def show
    @map = Map.find(params[:id])
    @location_base_url = locations_path
    @ask_location_permission = true
  end
end
