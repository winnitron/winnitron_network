FactoryBot.define do
  factory :attract do
    text { Faker::Lorem.sentence }
    arcade_machine
  end
end
