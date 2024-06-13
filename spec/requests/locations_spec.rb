# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Locations", type: :request do
  let(:map) { create(:map) }
  let(:location) { create(:location, :with_opening_times, map_id: map.id) }
  #let(:opening_time) { create(:opening_time, day: 1, location: location ) }

  describe "GET locations/show" do
    context "with no language param" do
      before do
        get map_location_path(map.hashid, location.hashid)
      end

      it "responds with a HTTP 200" do
        expect(response).to be_successful
      end

      it "contains opening times english (default)" do
        expect(response.body).to include("Monday")
      end
    end

    context "with no language param" do
      before do
        get map_location_path(map.hashid, location.hashid), params: {language: "de"}
      end

      it "responds with a HTTP 200" do
        expect(response).to be_successful
      end

       it "contains opening times german" do
        expect(response.body).to include("Montag")
      end
    end

  end
end
