# frozen_string_literal: true

# == Schema Information
#
# Table name: opening_times
#
#  id          :bigint           not null, primary key
#  closed      :boolean          default(FALSE), not null
#  closes_at   :time
#  day         :integer          not null
#  open_24h    :boolean          default(FALSE), not null
#  opens_at    :time
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  location_id :bigint
#
# Indexes
#
#  index_opening_times_on_day_and_location_id  (day,location_id) UNIQUE
#  index_opening_times_on_location_id          (location_id)
#
# Foreign Keys
#
#  fk_rails_...  (location_id => locations.id)
#
require "rails_helper"

RSpec.describe OpeningTime, type: :model do
  describe "attributes" do
    it do
      is_expected.to define_enum_for(:day).with_values(
        monday: 1, tuesday: 2, wednesday: 3, thursday: 4, friday: 5, saturday: 6, sunday: 7
      )
    end
  end

  describe "associations" do
    it { is_expected.to belong_to(:location) }
  end

  describe "validations" do
    let(:location) { create(:location) }

    it { is_expected.to allow_value(%w[true false]).for(:open_24h) }
    it { is_expected.to allow_value(%w[true false]).for(:closed) }
    it { is_expected.not_to allow_value(nil).for(:open_24h) }
    it { is_expected.not_to allow_value(nil).for(:closed) }

    it "is expected to validate that :day is unique, scoped_by :location_id" do
      described_class.create(day: 1, location: location)
      duplicate = described_class.new(day: 1, location: location)

      expect(duplicate).not_to be_valid
    end

    describe "#validate_format_as_string" do
      before { FactoryBot.rewind_sequences }

      context "when closed" do
        let(:opening_time) { build(:opening_time, closed: true) }

        it "is valid" do
          expect(opening_time.valid?).to be(true)
        end
      end

      context "when open24h" do
        let(:opening_time) { build(:opening_time, open_24h: true) }

        it "is valid" do
          expect(opening_time.valid?).to be(true)
        end
      end

      context "when opens_at & closes_at are both present" do
        let(:opening_time) { build(:opening_time, opens_at: "08:00", closes_at: "19:00") }

        it "is valid" do
          expect(opening_time.valid?).to be(true)
        end
      end

      context "when else" do
        let(:opening_time) { build(:opening_time, opens_at: "08:00", closes_at: nil) }

        it "is not valid" do
          expect(opening_time.valid?).to be(false)
        end
      end
    end
  end

  describe "scopes" do
    let(:monday) { create(:opening_time, day: :monday) }
    let(:sunday) { create(:opening_time, day: :sunday) }

    describe ".weekday" do
      it "includes opening_times on a weekday" do
        expect(described_class.weekday).to include(monday)
      end

      it "excludes opening_times during weekend" do
        expect(described_class.weekday).not_to include(sunday)
      end
    end

    describe ".weekend" do
      it "includes opening_times on weekend" do
        expect(described_class.weekend).to include(sunday)
      end

      it "excludes opening_times during weekday" do
        expect(described_class.weekend).not_to include(monday)
      end
    end
  end

  describe ".build_default" do
    it "builds 7 opening time objects" do
      expect(described_class.build_default.length).to be(7)
    end
  end

  describe ".time_options" do
    it "returns an array of 48 options" do
      expect(described_class.time_options.length).to be(48)
    end

    it "has 00:00 as its first item" do
      expect(described_class.time_options.first).to eq("00:00")
    end

    it "has 23:30 as its last item" do
      expect(described_class.time_options.last).to eq("23:30")
    end
  end

  describe ".format_as_string" do
    let(:opening_time) { create(:opening_time) }

    it "returns a non-empty string" do
      expect(opening_time.format_as_string).not_to be_empty
    end
  end
end
