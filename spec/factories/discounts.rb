require 'faker'

FactoryBot.define do
  factory :discount do
    association :merchant, factory: :merchant
    amount { Faker::Number.number(digits: 2) }
    threshold { Faker::Number.number(digits: 2) }
  end
end
