# frozen_string_literal: true

require "rails_helper"

RSpec.describe "interacting with the dashboard map", type: :feature, js: true do
  let(:location) { create(:location) }
  let(:map) { location.map }
  let(:user) { create(:user, account: create(:account), map: map) }

  before do
    sign_in user
    visit dashboard_map_path(map.hashid)
  end

  it "adds a location" do
    click_on("Add Location")
    fill_in("location_name", with: "Test Store")
    fill_in("location_address", with: "Lindenhofstrasse 200, 8001 Zurich, Switzerland")
    # the sleeping is required because it fetches the value from the Mapbox API
    sleep(1)
    page.first(".mapboxgl-ctrl-geocoder--suggestion").first(:xpath, ".//..").click
    sleep(1)
    expect { click_button("Save") }.to change(Location, :count).by(1)
  end
end
