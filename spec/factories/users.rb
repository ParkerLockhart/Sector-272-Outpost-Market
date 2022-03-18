FactoryBot.define do
  factory :user do
    username { Faker::Hipster.word }
    password { "password123" }
    password_confirmation { "password123" }
    role { 0 }
  end
end
