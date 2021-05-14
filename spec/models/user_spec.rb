# frozen_string_literal: true

require 'rails_helper'

describe User, type: :model do
  describe 'factory' do
    it 'has a valid factory' do
      expect(build(:user)).to be_valid
    end
  end

  describe 'validations' do
    before { create(:user) }

    context 'presence' do
      it { is_expected.to validate_presence_of :name }
      it { is_expected.to validate_presence_of :email }
    end

    context 'uniqueness' do
      it { is_expected.to validate_uniqueness_of(:email).case_insensitive }
    end
  end

  describe 'associations' do
    it { is_expected.to have_many(:maps) }
  end
end
