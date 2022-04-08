# frozen_string_literal: true

module CloudHelper
  def mapzy_cloud?
    ENV["MAPZY_CLOUD"] == "true"
  end
end
