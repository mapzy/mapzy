# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Maps', type: :request do
  let(:user) { create(:user) }
  let(:map) { create(:map, user_id: user.id) }

  before do
    sign_in user
  end

  describe 'GET maps/:id' do
    it 'responds with a HTTP 200' do
      get "/maps/#{map.id}"
      expect(response).to have_http_status(:ok)
    end
  end

  describe 'GET index' do
    it 'responds with a HTTP 302 Redirect' do
      get '/maps'
      expect(response).to have_http_status(:found)
    end
  end
end
