FactoryGirl.define do
  factory :game do
    title       { Faker::Lorem.words(3).join(" ") }
    description { Faker::Lorem.sentence(2) }
    zipfile_key { [Faker::Lorem.word, ".zip"].join }
    zipfile_last_modified { Time.now }
    min_players 1
    max_players 2

    after :create do |game|
      GameOwnership.create game: game, user: FactoryGirl.create(:user)
    end
  end
end