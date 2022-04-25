# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Locations", type: :request do
  let(:map) { create(:map) }
  let(:location) { create(:location, map_id: map.id) }

  describe "GET locations/show" do
    before do
      get map_location_path(map.hashid, location.hashid)
    end

    it "responds with a HTTP 200" do
      expect(response).to be_successful
    end
  end
end
