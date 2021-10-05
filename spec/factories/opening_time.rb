# frozen_string_literal: true

FactoryBot.define do
  factory :opening_time do
    day { :monday }
    opening_time { '08:00' }
    closing_time { '18:00' }

    association :location
  end
end
