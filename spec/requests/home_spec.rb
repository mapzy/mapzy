# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Home', type: :request do
  describe 'GET /' do
    it 'responds with a HTTP 200' do
      get '/'
      expect(response).to have_http_status(:ok)
    end
  end
end
