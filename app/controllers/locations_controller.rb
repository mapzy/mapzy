# frozen_string_literal: true

class LocationsController < ApplicationController
  def details
    @location = Location.find(params[:id])
  end
end
