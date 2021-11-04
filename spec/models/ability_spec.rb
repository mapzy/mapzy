# frozen_string_literal: true

require "rails_helper"

describe Ability, type: :model do
  let(:owner) { create(:user) }
  let(:fraud) { create(:user) }
  let(:map) { create(:map, user: owner) }
  let(:location) { create(:location, map: map) }

  context "when not logged in" do
    subject(:ability) { described_class.new(nil) }

    context "with maps" do
      it { is_expected.not_to be_able_to(:create, Map.new(user: owner)) }
      it { is_expected.not_to be_able_to(:read, map) }
      it { is_expected.not_to be_able_to(:update, map) }
      it { is_expected.not_to be_able_to(:destroy, map) }
    end

    context "with locations" do
      it { is_expected.not_to be_able_to(:create, Location.new(map: map)) }
      it { is_expected.not_to be_able_to(:read, location) }
      it { is_expected.not_to be_able_to(:update, location) }
      it { is_expected.not_to be_able_to(:destroy, location) }
    end
  end

  context "when logged in as owner" do
    subject(:ability) { described_class.new(owner) }

    context "with maps" do
      it { is_expected.to be_able_to(:create, Map.new(user: owner)) }
      it { is_expected.to be_able_to(:read, map) }
      it { is_expected.to be_able_to(:update, map) }
      it { is_expected.to be_able_to(:destroy, map) }
    end

    context "with locations" do
      it { is_expected.to be_able_to(:create, Location.new(map: map)) }
      it { is_expected.to be_able_to(:read, location) }
      it { is_expected.to be_able_to(:update, location) }
      it { is_expected.to be_able_to(:destroy, location) }
    end
  end

  context "when logged in as someone else" do
    subject(:ability) { described_class.new(fraud) }

    context "with maps" do
      it { is_expected.not_to be_able_to(:create, Map.new(user: owner)) }
      it { is_expected.not_to be_able_to(:read, map) }
      it { is_expected.not_to be_able_to(:update, map) }
      it { is_expected.not_to be_able_to(:destroy, map) }
    end

    context "with locations" do
      it { is_expected.not_to be_able_to(:create, Location.new(map: map)) }
      it { is_expected.not_to be_able_to(:read, location) }
      it { is_expected.not_to be_able_to(:update, location) }
      it { is_expected.not_to be_able_to(:destroy, location) }
    end
  end
end
