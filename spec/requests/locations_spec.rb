# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Locations', type: :request do
  let(:user) { create(:user) }

  before do
    sign_in user
  end

  describe 'GET locations/new' do
    it 'responds with a HTTP 200' do
      get '/locations/new'
      expect(response).to have_http_status(:ok)
    end
  end
end
