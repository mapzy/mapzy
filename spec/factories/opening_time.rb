# frozen_string_literal: true

FactoryBot.define do
  factory :opening_time do
    day { :monday }
    opens_at { '08:00' }
    closes_at { '18:00' }
    open_24h { false }
    closed { false }

    association :location
  end
end
