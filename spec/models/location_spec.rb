require 'rails_helper'

RSpec.describe Location, type: :model do
  describe "factory" do
    it "has a valid factory" do
      expect(build(:location)).to be_valid
    end
  end

  describe "associations" do
    it { should belong_to(:map) }
  end
end
