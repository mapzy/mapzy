# frozen_string_literal: true

class MapsController < ApplicationController
  def show
    @map = Map.find(params[:id])
    @bounds = @map.bounds
    @markers_json = @map.markers.to_json
  end
end
