FactoryGirl.define do
  factory :game do
    title       { Faker::Lorem.words(3).join(" ") }
    description { Faker::Lorem.sentence(2) }
    s3_key      { [Faker::Lorem.word, ".zip"].join }
  end
end