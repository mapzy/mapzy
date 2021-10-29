# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Locations", type: :request do
  let(:user) { create(:user) }
  let(:map) { create(:map, user: user) }
  let(:location) { create(:location, map: map) }

  before do
    sign_in user
  end

  describe "GET locations/new" do
    it "responds with a HTTP 200" do
      get new_dashboard_map_location_path(map_id: map.id)
      expect(response).to be_successful
    end
  end

  describe "GET locations/show" do
    before do
      get dashboard_map_location_path(map_id: map.id, id: location.id)
    end

    it "responds with a HTTP 200" do
      expect(response).to be_successful
    end

    it "contains the correct turbo-frame" do
      expect(response.body).to include('<turbo-frame id="location_view">')
    end
  end
end
