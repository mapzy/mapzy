# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Maps", type: :request do
  let(:user) { create(:user) }
  let(:map) { create(:map, user_id: user.id) }

  before do
    sign_in user
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
end
