FactoryBot.define do
  factory :high_score do
    name  { Faker::Name.first_name }
    score { rand(10000) }
    game
    arcade_machine
  end
end