# frozen_string_literal: true

class LocationsController < ApplicationController
  include Trackable

  after_action -> { track_event("Viewed Location") }, only: %i[show]

  def new; end

  def create; end

  def show
    @location = Location.find(params[:id])
  end
end
