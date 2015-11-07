FactoryGirl.define do
  factory :user do
    password { Faker::Internet.password(8) }
  end
end
