FactoryBot.define do
  factory :opening_time do
    weekday { 1 }
    opening_time { Time.new.in_time_zone('08:00') }
    opening_time { Time.new.in_time_zone('18:00') }

    association :location
  end
end
