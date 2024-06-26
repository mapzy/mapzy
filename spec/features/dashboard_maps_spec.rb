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
    sleep(2)
    page.first(".mapboxgl-ctrl-geocoder--suggestion").first(:xpath, ".//..").click
    sleep(1)
    prev_locations_count = Location.count
    find("[value=Save]").click
    sleep(2)
    expect(prev_locations_count + 1).to eq(Location.count)
  end

  # rubocop:disable RSpec/MultipleExpectations
  it "shows opening times per default" do
    click_on("Add Location")
    expect(page).to have_content("MONDAY")
    expect(page).to have_field(
      "location_opening_times_attributes___destroy",
      type: :hidden,
      with: "false"
    )
  end

  it "hides opening times if checked" do
    click_on("Add Location")
    check("no_opening_times")
    expect(page).not_to have_content("MONDAY")
    expect(page).to have_field(
      "location_opening_times_attributes___destroy",
      type: :hidden,
      with: "true"
    )
  end
  # rubocop:enable RSpec/MultipleExpectations

  it "hides time dropdowns if closed is checked" do
    click_on("Add Location")
    first("#location_opening_times_attributes__closed").check
    expect(page).to have_selector("#location_opening_times_attributes__opens_at", count: 4)
  end
end
