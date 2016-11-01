FactoryGirl.define do
  factory :game do
    title       { Faker::Lorem.words(3).join(" ") }
    description { Faker::Lorem.sentence(2) }
    uuid        SecureRandom.uuid
    min_players 1
    max_players 2

    after :create do |game|
      owner =
      GameOwnership.create game: game, user: owner

      GameZip.create(game:     game,
                     user:     FactoryGirl.create(:user),
                     file_key: [Faker::Lorem.word, ".zip"].join,
                     file_last_modified: Time.now)
    end
  end
end