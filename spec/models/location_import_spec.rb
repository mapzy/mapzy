# frozen_string_literal: true

require "rails_helper"

RSpec.describe Account, type: :model do
  let(:map) { create(:map) }
  let(:csv_row) do
    {
      "0" => "Test Location",
      "1" => "Very fun test location!",
      "2" => "200 Kent Ave, Brooklyn, NY 11249, United States",
      "3" => "",
      "4" => "08:00",
      "5" => "18:00",
      "6" => "08:00",
      "7" => "18:00",
      "8" => "08:00",
      "9" => "18:00",
      "10 " => "08:00",
      "11" => "18:00",
      "12" => "08:00",
      "13" => "18:00",
      "14" => "24",
      "15" => "24",
      "16" => "",
      "17" => ""
    }
  end

  describe "class methods" do
    describe ".open_24h?" do
      it "is true for values 24 and 24" do
        expect(LocationImport.open_24h?("24", "24")).to be(true)
      end

      it "is false other values than 24 and 24" do
        expect(LocationImport.open_24h?("24", "22")).to be(false)
      end
    end

    describe ".closed?" do
      it "is true for blank values" do
        expect(LocationImport.closed?("", "")).to be(true)
      end

      it "is true for nil values" do
        expect(LocationImport.closed?(nil, nil)).to be(true)
      end

      it "is false for non-blank values" do
        expect(LocationImport.closed?("10:00", "18:00")).to be(false)
      end
    end

    describe ".row_empty?" do
      let(:empty_row) { { "0" => "", "1" => "", "2" => "" } }
      let(:non_empty_row) { { "0" => "hello", "1" => "", "2" => "" } }

      it "is true for blank values" do
        expect(LocationImport.row_empty?(empty_row)).to be(true)
      end

      it "is false if one of the values is not blank" do
        expect(LocationImport.row_empty?(non_empty_row)).to be(false)
      end
    end

    describe ".opening_times_from_csv" do
      let(:monday) do
        {
          day: :monday,
          opens_at: "08:00",
          closes_at: "18:00",
          open_24h: false,
          closed: false
        }
      end

      let(:saturday) do
        {
          day: :saturday,
          opens_at: "",
          closes_at: "",
          open_24h: true,
          closed: false
        }
      end

      let(:sunday) do
        {
          day: :sunday,
          opens_at: "",
          closes_at: "",
          open_24h: false,
          closed: true
        }
      end

      it "returns correct opening_times for monday (regular)" do
        expect(LocationImport.opening_times_from_csv(csv_row)[0]).to eq(monday)
      end

      it "returns correct opening_times for saturday (open 24h)" do
        expect(LocationImport.opening_times_from_csv(csv_row)[5]).to eq(saturday)
      end

      it "returns correct opening_times for sunday (closed)" do
        expect(LocationImport.opening_times_from_csv(csv_row)[6]).to eq(sunday)
      end
    end
  end

  describe "instance methods" do
    def location_import(csv_row)
      LocationImport.new(map, csv_row)
    end

    describe ".initialize" do
      let(:name_error) do
        { 2 => { cells: [1], full_message: ["Name can't be blank"] } }
      end

      let(:address_error) do
        { 2 => { cells: [3], full_message: ["Address can't be blank"] } }
      end

      let(:opening_time_error) do
        {
          2 =>
            {
              cells: [5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18],
              full_message: ["Opening times opens at can't be blank"]
            }
        }
      end

      it "validates correctly after initialization" do
        expect(location_import([csv_row]).errors).to be_empty
      end

      it "returns name error if no location name provided" do
        csv_row["0"] = ""
        expect(location_import([csv_row]).errors).to eq(name_error)
      end

      it "returns address error if no address name provided" do
        csv_row["2"] = ""
        expect(location_import([csv_row]).errors).to eq(address_error)
      end

      it "returns opening time error if opens_at missing provided" do
        csv_row["4"] = ""
        expect(location_import([csv_row]).errors).to eq(opening_time_error)
      end

      it "returns opening time error if non-time input provided" do
        csv_row["4"] = "bla"
        expect(location_import([csv_row]).errors).to eq(opening_time_error)
      end

      it "sets longitude corretly" do
        expect(
          location_import([csv_row]).instance_variable_get(:@locations).first.longitude
        ).to eq(0)
      end

      it "sets latitude corretly" do
        expect(
          location_import([csv_row]).instance_variable_get(:@locations).first.latitude
        ).to eq(0)
      end
    end
  end
end
