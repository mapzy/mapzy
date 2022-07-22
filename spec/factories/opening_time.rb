# frozen_string_literal: true

FactoryBot.define do
  factory :opening_time do
    # day { :monday }
    sequence :day, 0 do |n|
      OpeningTime.days.keys[n]
    end
    opens_at { "08:00" }
    closes_at { "18:00" }
    open_24h { false }
    closed { false }

    association :location
  end
end
