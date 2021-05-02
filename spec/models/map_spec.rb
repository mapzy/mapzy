require 'rails_helper'

RSpec.describe Map, type: :model do
  describe "factory" do
    it "has a valid factory" do
      expect(build(:map)).to be_valid
    end
  end

  describe "associations" do
    it { should belong_to(:user) }
  end
end
