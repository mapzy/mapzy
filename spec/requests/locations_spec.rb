# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Locations', type: :request do
  let(:location) { create(:location) }
  let(:user) { location.map.user }

  before do
    sign_in user
  end

  describe 'GET locations/new' do
    it 'responds with a HTTP 200' do
      get locations_path
      expect(response).to be_successful
    end
  end

  describe 'GET locations/show' do
    before do
      get location_path(location.id)
    end

    it 'responds with a HTTP 200' do
      expect(response).to be_successful
    end

    it 'contains the correct turbo-frame' do
      expect(response.body).to include('<turbo-frame id="location_description">')
    end
  end
end
