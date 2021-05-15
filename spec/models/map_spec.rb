# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Map, type: :model do
  describe 'factory' do
    it 'has a valid factory' do
      expect(build(:map)).to be_valid
    end
  end

  describe 'associations' do
    it { is_expected.to belong_to(:user) }
    it { is_expected.to have_many(:locations) }
  end
end
