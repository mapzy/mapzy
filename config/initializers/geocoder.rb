# frozen_string_literal: true

Geocoder.configure(
  timeout: 5,
  lookup: :mapbox,
  api_key: ENV["MAPBOX_ACCESS_TOKEN"],
  units: :km,
  use_https: true,
  mapbox: {
    types: "address",
    limit: 1
  }
)
