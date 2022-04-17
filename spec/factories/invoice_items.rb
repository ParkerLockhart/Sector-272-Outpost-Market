require 'faker'
FactoryBot.define do
  factory :invoice_item do
    association :invoice, factory: :invoice
    association :item, factory: :item
    quantity { Faker::Number.number(digits: 2) }
    calculated_price { Faker::Number.number(digits: 4) }
    status { ['packaged', 'pending', 'shipped'].sample }
  end
end
