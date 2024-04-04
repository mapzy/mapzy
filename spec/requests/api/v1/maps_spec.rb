# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Maps", type: :request do
  let(:user) { create(:user) }
  let(:map) { create(:map, user_id: user.id, sync_mode: true) }

  let(:bearer_token) { "Bearer #{map.api_key.key_value}" }
  let(:locations_payload) { locations_payload_data }

  describe "POST sync" do
    context "with valid payload" do
      it "returns 200" do
        post api_v1_maps_sync_path(map.hashid),
             as: :json, params: locations_payload, headers: { Authorization: bearer_token }
        expect(response).to have_http_status(:success)
      end

      it "starts the background job with SyncWorker" do
        expect do
          post api_v1_maps_sync_path(map.hashid),
               as: :json, params: locations_payload, headers: { Authorization: bearer_token }
        end.to have_enqueued_job(SyncJob).exactly(:once)
      end
    end

    context "with invalid payload" do
      before do
        locations_payload.first[:name] = ""
      end

      it "returns 422" do
        post api_v1_maps_sync_path(map.hashid),
             as: :json, params: locations_payload, headers: { Authorization: bearer_token }
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it "doesn't start the background job with SyncWorker" do
        expect do
          post api_v1_maps_sync_path(map.hashid),
               as: :json, params: locations_payload, headers: { Authorization: bearer_token }
        end.to have_enqueued_job(SyncJob).exactly(0).times
      end
    end

    context "with invalid api key" do
      it "returns 401" do
        post api_v1_maps_sync_path(map.hashid),
             as: :json, params: locations_payload, headers: { Authorization: "bla" }
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context "with sync mode turned off" do
      it "returns 422" do
        map.sync_mode = "false"
        map.save

        post api_v1_maps_sync_path(map.hashid),
             as: :json, params: locations_payload, headers: { Authorization: bearer_token }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end
end
