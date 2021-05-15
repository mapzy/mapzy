# frozen_string_literal: true

FactoryBot.define do
  factory :map do
    name { 'My beautiful map' }
    association :user
  end
end
