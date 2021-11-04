# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Maps", type: :request do
  let(:map) { create(:map) }

  describe "GET maps/:id" do
    it "responds with a HTTP 200" do
      get map_path(map.id)
      expect(response).to be_successful
    end
  end
end
