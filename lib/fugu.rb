# frozen_string_literal: true

module Fugu
  def self.track(name, properties = {})
    body = {
      api_key: ENV["FUGU_API_KEY"],
      name: name,
      properties: properties
    }

    Faraday.post(ENV["FUGU_URL"]) do |req|
      req.headers["Content-Type"] = "application/json"
      req.body = body.to_json
    end
  end
end
