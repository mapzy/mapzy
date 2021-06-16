# frozen_string_literal: true

class LocationsController < ApplicationController
  def new; end

  def create; end

  def show
    @location = Location.find(params[:id])
  end
end
