FactoryGirl.define do
  factory :playlist do
    title { Faker::Lorem.words(2).join(" ") }
    user
  end
end