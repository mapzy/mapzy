# frozen_string_literal: true

class LocationImport
  ROW_OFFSET = 1
  COL_OFFSET = 2
  TRUTHY = %w[yes true jep y].freeze

  def initialize(**args)
    map = args[:map]

    @location = map.locations.build(
      skip_geocoding: true,
      name: args[:name],
      description: args[:description],
      address: args[:address],
      opening_times_attributes: args[:opening_times]
    )
  end

  def valid?
    @location.valid?
  end

  def errors_to_spreadsheet
    # maps errors to spreadsheet columns
    cells = []
    @location.errors.attribute_names.each do |attr|
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
      full_message: @location.errors.full_messages
    }
  end

  def self.open_24h?(opens_at, closes_at)
    opens_at == "24" && closes_at == "24"
  end

  def self.closed?(opens_at, closes_at)
    opens_at.blank? && closes_at.blank?
  end

  def self.validate_csv(map, data)
    errors = {}
    data.each_with_index do |d, i|
      next if row_empty?(d)

      location_import = LocationImport.new(
        skip_geocoding: true,
        map: map,
        name: d["0"],
        description: d["1"],
        address: d["2"],
        opening_times: opening_times_from_csv(d)
      )
      errors[i + COL_OFFSET] = location_import.errors_to_spreadsheet unless location_import.valid?
    end

    errors
  end

  def self.row_empty?(row_data)
    # no name, description and address entered
    row_data["0"].blank? && row_data["1"].blank? && row_data["2"].blank?
  end

  def self.opening_times_from_csv(row_data)
    opening_times = []
    return opening_times if TRUTHY.include?(row_data["3"].strip.downcase)

    # remove non opening time data
    opening_times_csv = row_data.except("0", "1", "2", "3").values
    index = 0
    OpeningTime::ALL_DAYS.each do |day|
      opens_at = opening_times_csv[index]
      closes_at = opening_times_csv[index + 1]
      open_24h = open_24h?(opens_at, closes_at)
      closed = closed?(opens_at, closes_at)
      opening_times.push(
        {
          day: day,
          opens_at: !closed && !open_24h ? opens_at : "",
          closes_at: !closed && !open_24h ? closes_at : "",
          open_24h: open_24h,
          closed: closed
        }
      )
      index += 2
    end
    opening_times
  end
end
