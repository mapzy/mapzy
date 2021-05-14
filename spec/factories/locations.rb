FactoryBot.define do
  factory :location do
    name { 'Mapzy HQ' }
    description { 'The coolest place to be' }
    street_name { 'Hohlstrasse' }
    street_number { '117' }
    city { 'Zürich' }
    zip_code { '8004' }
    country_code { 'CH' }
    lat { 12.222211 }
    long { 8.433332 }
    association :map
  end
end