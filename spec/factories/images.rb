FactoryBot.define do
  factory :image do
    file_key { "#{Faker::Lorem.word}.jpg" }
    file_last_modified { Faker::Time.backward(30) }
    user
  end
end