# frozen_string_literal: true

class LocationImport
  ROW_OFFSET = 1
  COL_OFFSET = 2
  TRUTHY = %w[yes true jep y ja oui si evet].freeze

  attr_reader :errors

  def initialize(map, spreadsheet_data)
    @map = map
    @spreadsheet_data = spreadsheet_data
    @errors = {}
    @locations = []

    validate_csv
  end

  def validate_csv
    @spreadsheet_data.each_with_index do |d, i|
      next if LocationImport.row_empty?(d)

      location = @map.locations.build(
        skip_geocoding: true,
        name: d["0"],
        description: d["1"],
        address: d["2"],
        opening_times_attributes: LocationImport.opening_times_from_csv(d)
      )
      if location.valid?
        @locations.push(location)
      else
        @errors[i + COL_OFFSET] = LocationImport.errors_to_spreadsheet(location)
      end
    end
  end

  def insert_all
    # insert all doesn't do validations, therefore we need to make sure that we have no errors
    return if @errors.present?

    Location.import(@locations, validate: false, all_or_none: true, recursive: true)
  end

  def self.errors_to_spreadsheet(location)
    # maps errors to spreadsheet columns
    cells = []
    location.errors.attribute_names.each do |attr|
      case attr
      when :name
        cells.push(0 + ROW_OFFSET)
      when :description
        cells.push(1 + ROW_OFFSET)
      when :address
        cells.push(2 + ROW_OFFSET)
      when :"opening_times.opens_at", :"opening_times.closes_at"
        # we don't get the error per opening time back, therefore we highlight all opening times
        s = 4 + ROW_OFFSET
        e = s + 13
        cells.concat((s..e).to_a)
      end
    end
    {
      cells: cells,
      full_message: location.errors.full_messages
    }
  end

  def self.open_24h?(opens_at, closes_at)
    opens_at == "24" && closes_at == "24"
  end

  def self.closed?(opens_at, closes_at)
    opens_at.blank? && closes_at.blank?
  end

  def self.row_empty?(row_data)
    # no name, description and address entered
    row_data["0"].blank? && row_data["1"].blank? && row_data["2"].blank?
  end

  def self.opening_times_from_csv(row_data)
    opening_times = []
    return opening_times if TRUTHY.include?(row_data["3"]&.strip&.downcase)

    # remove non opening time data
    opening_times_csv = row_data.except("0", "1", "2", "3").values
    index = 0
    OpeningTime::ALL_DAYS.each do |day|
      opening_times.push(
        LocationImport.format_opening_time(
          day,
          opening_times_csv[index],
          opening_times_csv[index + 1]
        )
      )
      index += 2
    end
    opening_times
  end

  def self.format_opening_time(day, opens_at, closes_at)
    # creates corretly formatted opening time
    open_24h = LocationImport.open_24h?(opens_at, closes_at)
    closed = LocationImport.closed?(opens_at, closes_at)
    {
      day: day,
      opens_at: !closed && !open_24h ? opens_at : "",
      closes_at: !closed && !open_24h ? closes_at : "",
      open_24h: open_24h,
      closed: closed
    }
  end
end
