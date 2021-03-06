# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Locations", type: :request do
  let(:user) { create(:user) }
  let(:map) { create(:map, user: user) }
  let(:location) { create(:location, map: map) }
  let(:location_params) { locations_payload_data.first }

  before do
    sign_in user
  end

  describe "GET locations/new" do
    it "responds with a HTTP 200" do
      get new_dashboard_map_location_path(map_id: map.hashid)
      expect(response).to be_successful
    end
  end

  describe "GET locations/show" do
    before do
      get dashboard_map_location_path(map_id: map.hashid, id: location.hashid)
    end

    it "responds with a HTTP 200" do
      expect(response).to be_successful
    end
  end

  describe "POST locations/create" do
    before do
      sign_in user
    end

    context "with opening_times" do
      it "responds with a HTTP 200" do
        post dashboard_map_locations_path(map), params: { location: location_params }
        expect(response).to redirect_to dashboard_map_path(map)
      end

      it "creates a location in the database" do
        expect do
          post dashboard_map_locations_path(map), params: { location: location_params }
        end.to change(Location, :count)
      end

      it "creates the correct location" do
        post dashboard_map_locations_path(map), params: { location: location_params }
        expect(Location.where(name: location_params[:name])).to exist
      end

      it "creates the opening times" do
        post dashboard_map_locations_path(map), params: { location: location_params }
        new_location = Location.find_by(name: location_params[:name])
        expect(OpeningTime.where(location: new_location)).to exist
      end
    end

    context "without opening_times" do
      before do
        location_params[:opening_times_attributes] = []
        location_params[:no_opening_times] = "yes"
      end

      it "responds with a HTTP 200" do
        post dashboard_map_locations_path(map), params: { location: location_params }
        expect(response).to redirect_to dashboard_map_path(map)
      end

      it "creates a location in the database" do
        expect do
          post dashboard_map_locations_path(map), params: { location: location_params }
        end.to change(Location, :count)
      end

      it "creates the correct location" do
        post dashboard_map_locations_path(map), params: { location: location_params }
        expect(Location.where(name: location_params[:name])).to exist
      end

      it "doesn't create the opening times" do
        post dashboard_map_locations_path(map), params: { location: location_params }
        new_location = Location.find_by(name: location_params[:name])
        expect(OpeningTime.where(location: new_location)).not_to exist
      end
    end
  end

  describe "PATCH locations/create" do
    context "with opening_times" do
      it "responds with a HTTP 200" do
        patch dashboard_map_location_path(map, location), params: { location: location_params }
        expect(response).to redirect_to dashboard_map_path(map)
      end

      it "updates to the correct location" do
        patch dashboard_map_location_path(map, location), params: { location: location_params }
        expect(Location.where(name: location_params[:name])).to exist
      end

      it "creates the opening times" do
        patch dashboard_map_location_path(map, location), params: { location: location_params }
        new_location = Location.find_by(name: location_params[:name])
        expect(OpeningTime.where(location: new_location)).to exist
      end
    end

    context "without opening_times" do
      before do
        location_params[:opening_times_attributes] = []
        location_params[:no_opening_times] = "yes"
      end

      it "responds with a HTTP 200" do
        patch dashboard_map_location_path(map, location), params: { location: location_params }
        expect(response).to redirect_to dashboard_map_path(map)
      end

      it "updates to the correct location" do
        patch dashboard_map_location_path(map, location), params: { location: location_params }
        expect(Location.where(name: location_params[:name])).to exist
      end

      it "deletes the opening times" do
        patch dashboard_map_location_path(map, location), params: { location: location_params }
        updated_location = Location.find_by(name: location_params[:name])
        expect(OpeningTime.where(location: updated_location)).not_to exist
      end
    end
  end
end
