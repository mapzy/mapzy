# frozen_string_literal: true

require "rails_helper"

RSpec.describe "interacting with the map", type: :feature, :js => true do
  let(:location) { create(:location) }
  let(:map) { location.map }

  before do
    visit map_path(map.id)
  end

  it "does not show location name before click" do
    expect(page).not_to have_content(location.name)
  end

  it "shows location view on pin click" do
    page.scroll_to(page.find_link(href: location_path(location.hashid))).click
    expect(page).to have_content(location.name)
  end
end
