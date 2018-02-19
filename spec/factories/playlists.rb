FactoryBot.define do
  factory :playlist do
    title { Faker::Lorem.words(3).join(" ") }
    user
  end
end