require 'faker'
FactoryBot.define do
  factory :item do
    name { Faker::Commerce.product_name }
    description { Faker::Commerce.color + '' + Faker::Commerce.material }
    unit_price { Faker::Commerce.price }
    association :merchant, factory: :merchant
  end
end
