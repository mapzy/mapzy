# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Maps", type: :request do
  let(:user) { create(:user) }
  let(:map) { create(:map, user_id: user.id) }

  before do
    sign_in user
    create(:account, user: user)
  end

  describe "GET index" do
    it "responds with a HTTP 302 Redirect" do
      get dashboard_maps_path
      expect(response).to have_http_status(:found)
    end
  end

  describe "GET maps/:id" do
    it "responds with a HTTP 200" do
      get dashboard_map_path(id: map.id)
      expect(response).to be_successful
    end
  end

  describe "PATCH maps/:id" do
    context "with setting sync mode to true" do
      let(:sync_mode_true) { { id: map.id, sync_mode: true } }

      before do
        map.sync_mode = false
        map.save
      end

      it "responds with a HTTP 200" do
        patch dashboard_map_path(id: map.id, params: { map: sync_mode_true }), as: :turbo_stream
        expect(response).to be_successful
      end

      it "updates sync mode in database" do
        patch dashboard_map_path(id: map.id, params: { map: sync_mode_true }), as: :turbo_stream
        expect(Map.find(map.id).sync_mode).to be true
      end
    end

    context "with updating sync mode to false" do
      let(:sync_mode_false) { { id: map.id, sync_mode: false } }

      before do
        map.sync_mode = true
        map.save
      end

      it "responds with a HTTP 200" do
        patch dashboard_map_path(id: map.id, params: { map: sync_mode_false }), as: :turbo_stream
        expect(response).to be_successful
      end

      it "updates sync mode in database" do
        patch dashboard_map_path(id: map.id, params: { map: sync_mode_false }), as: :turbo_stream
        expect(Map.find(map.id).sync_mode).to be false
      end
    end

    context "with changing main color" do
      let(:color_map) { { id: map.id, custom_color: "#fff" } }

      before do
        map.custom_color = "#000"
        map.save
      end

      it "responds with a HTTP 200" do
        patch dashboard_map_path(id: map.id, params: { map: color_map }), as: :turbo_stream
        expect(response).to be_successful
      end

      it "updates sync mode in database" do
        patch dashboard_map_path(id: map.id, params: { custom_color: "#000" }), as: :turbo_stream
         expect(Map.find(map.id).custom_color).to eq("#000")
      end
    end

    context "with changing accent color" do
      let(:color_map) { { id: map.id, custom_color: "#fff" } }

      before do
        map.custom_accent_color = "#000"
        map.save
      end

      it "responds with a HTTP 200" do
        patch dashboard_map_path(id: map.id, params: { map: color_map }), as: :turbo_stream
        expect(response).to be_successful
      end

      it "updates sync mode in database" do
        patch dashboard_map_path(id: map.id, params: { custom_accent_color: "#000" }), as: :turbo_stream
         expect(Map.find(map.id).custom_accent_color).to eq("#000")
      end
    end
  end
end
