FactoryGirl.define do
  factory :organization do
    name { Faker::Internet.user_name }
  end
end
