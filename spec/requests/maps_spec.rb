# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Maps', type: :request do
  let(:user) { create(:user) }

  before(:each) do
    sign_in user
  end

  describe 'GET maps/:id' do
    it 'responds with a HTTP 200' do
      get '/maps/1'
      expect(response).to have_http_status(200)
    end
  end

  describe 'GET index' do
    it 'responds with a HTTP 302 Redirect' do
      get authenticated_root_path
      expect(response).to have_http_status(302)
    end
  end
end
