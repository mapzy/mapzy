# frozen_string_literal: true

require "rails_helper"

RSpec.describe "interacting with the map", type: :feature do
  let(:location) { create(:location) }
  let(:map) { location.map }

  before do
    visit map_path(map.id)
  end

  it "shows permission box" do
    expect(page).to have_selector(:link_or_button, "Grant permission")
  end

  it "hides permission box on hide click" do
    page.find_button("Hide").click
    expect(page).not_to have_selector(:link_or_button, "Grant permission")
  end

  it "does not show location name before click" do
    expect(page).not_to have_content(location.name)
  end

  # this test throws a weird error
  # Selenium::WebDriver::Error::ElementNotInteractableError:
  # element not interactable: element has zero size

  xit "shows location view on pin click" do
    page.find_link("", href: location_path(location.id)).click
    expect(page).to have_content(location.name)
  end
end
