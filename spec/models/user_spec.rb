require 'rails_helper'

describe User, :type => :model do

  context "factory" do
    it "has a valid factory" do
      expect(build(:user)).to be_valid
    end
  end

  context "validations" do
    before { create(:user) }

    context "presence" do
      it { should validate_presence_of :name }
      it { should validate_presence_of :email }
    end

    context "uniqueness" do
      it { should validate_uniqueness_of(:email).case_insensitive }
    end
  end
end