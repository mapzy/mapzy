# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Maps', type: :request do
  before(:all) do
    user = User.create
    sign_in user
  end

  describe 'GET maps/:id' do
    it 'responds with a HTTP 200' do
      get '/maps/1'
      expect(response).to have_http_status(200)
    end
  end
end
