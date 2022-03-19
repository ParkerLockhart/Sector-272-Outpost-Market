FactoryBot.define do
  factory :merchant_user do
    association :merchant, factory: :merchant
    association :user, factory: :user
  end
end 
