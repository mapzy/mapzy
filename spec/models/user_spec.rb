# frozen_string_literal: true

# == Schema Information
#
# Table name: users
#
#  id                     :bigint           not null, primary key
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  name                   :string
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
# Indexes
#
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#
require 'rails_helper'

describe User, type: :model do
  describe 'factory' do
    it 'has a valid factory' do
      expect(build(:user)).to be_valid
    end
  end

  describe 'validations' do
    before { create(:user) }

    describe 'presence' do
      it { is_expected.to validate_presence_of :name }
      it { is_expected.to validate_presence_of :email }
    end

    describe 'uniqueness' do
      it { is_expected.to validate_uniqueness_of(:email).case_insensitive }
    end
  end

  describe 'associations' do
    it { is_expected.to have_many(:maps) }
  end

  describe 'abilities' do
    subject(:ability) { Ability.new(user) }

    let(:user) { described_class.new }
    let(:map) { Map.new(user: user) }

    context 'with maps' do
      it { is_expected.to be_able_to(:manage, Map.new) }
    end

    context 'with locations' do
      it { is_expected.to be_able_to(:manage, Location.new(map: map)) }
    end
  end

  describe '.create_default_map' do
    let(:user) { create(:user) }

    it 'creates a new Map' do
      expect do
        user.create_default_map
      end.to change(Map, :count).by(1)
    end
  end

  describe '.find_or_create_default_map' do
    subject(:find_or_create_default_map) { user.find_or_create_default_map }

    let(:user) { create(:user) }

    context 'when default map already exists' do
      it 'does not create a new map' do
        create(:map, user: user)
        expect { find_or_create_default_map }.not_to change(Map, :count)
      end
    end

    context 'when default map do not exist' do
      let(:create_default_map) { instance_double('create_default_map') }

      it 'calls .create_default_map' do
        expect(user).to receive(:create_default_map)
        find_or_create_default_map
      end
    end
  end
end
