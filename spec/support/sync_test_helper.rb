# frozen_string_literal: true

module SyncTestHelper
  def locations_payload_data
    [
      {
        name: "Test Location 2",
        description: "Very hey",
        address: "Hohlstrasse 117, 8002 Zürich Switzerland",
        latitude: "",
        longitude: "",
        opening_times_attributes: opening_times_valid
      }
    ]
  end

  # rubocop:disable Metrics/MethodLength
  def opening_times_valid
    [
      {
        day: "monday",
        opens_at: "10:00",
        closes_at: "20:00",
        closed: false,
        open_24h: false
      },
      {
        day: "tuesday",
        opens_at: "10:00",
        closes_at: "20:00",
        closed: false,
        open_24h: false
      },
      {
        day: "wednesday",
        opens_at: "10:00",
        closes_at: "20:00",
        closed: false,
        open_24h: false
      },
      {
        day: "thursday",
        opens_at: "10:00",
        closes_at: "20:00",
        closed: false,
        open_24h: false
      },
      {
        day: "friday",
        opens_at: "10:00",
        closes_at: "20:00",
        closed: false,
        open_24h: false
      },
      {
        day: "saturday",
        opens_at: "",
        closes_at: "",
        closed: false,
        open_24h: true
      },
      {
        day: "sunday",
        opens_at: "",
        closes_at: "",
        closed: true,
        open_24h: false
      }
    ]
  end
  # rubocop:enable Metrics/MethodLength
end
