require 'faker'
FactoryBot.define do
  factory :invoice do
    association :customer, factory: :customer
    association :merchant, factory: :merchant
    status { [0, 1, 2].sample }
    total { Faker::Number.number(digits: 4) }
  end
end
