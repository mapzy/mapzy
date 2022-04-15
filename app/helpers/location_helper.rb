# frozen_string_literal: true

module LocationHelper
  def no_opening_times?(location)
    location.id.present? && location.opening_times.empty?
  end
end
