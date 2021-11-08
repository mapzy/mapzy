# frozen_string_literal: true

require "rails_helper"

RSpec.describe "interacting with the dashboard map", type: :feature do
  let(:user) { create(:user, account: create(:account)) }
  let(:map) { create(:map, user: user) }
  let(:location) { create(:location, map: map) }

  before do
    sign_in user
    visit dashboard_map_path(map.id)
  end

  it "show embed code on click" do
    page.find_link("Show Embed Code").click
    expect(page).to have_selector("h1", text: "Your Embed Code", visible: "true")
  end

  it "hide show embed code on click" do
    page.find_link("Show Embed Code").click
    page.find_link("Hide Embed Code").click
    expect(page).not_to have_selector("h1", text: "Your Embed Code")
  end
end
