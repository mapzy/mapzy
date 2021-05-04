class MapsController < ApplicationController

  def index
    puts "dd"
  end

  def show
    puts "dddddd"
  end

  def maps_test
    return render :html => '<turbo-frame id="location_description">yuhhuuu</turbo-frame>'.html_safe
  end
end
