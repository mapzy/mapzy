# frozen_string_literal: true

class MapsController < ApplicationController
  def show
    markers = {
      type: 'FeatureCollection',
      features: [
        {
          type: 'Feature',
          geometry: {
            type: 'Point',
            coordinates: [12.554729, 55.70651]
          },
          properties: {
            prop0: 'value0'
          }
        },
        {
          type: 'Feature',
          geometry: {
            type: 'Point',
            coordinates: [12.65147, 55.608166]
          },
          properties: {
            prop0: 'value0'
          }
        }
      ]
    }

    lats = markers[:features].map { |f| f[:geometry][:coordinates][0] }
    longs = markers[:features].map { |f| f[:geometry][:coordinates][1] }

    west, east = lats.minmax
    south, north = longs.minmax

    @bounds = [[west, south], [east, north]]

    @markers_json = markers.to_json
  end

  def maps_test
    render html: '<turbo-frame id="location_description">yuhhuuu</turbo-frame>'.html_safe
  end
end
