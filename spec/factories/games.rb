FactoryGirl.define do
  factory :game do
    title        { Faker::Lorem.words(4).join(" ") }
    description  { Faker::Lorem.sentence(2) }
    uuid         { SecureRandom.uuid }
    min_players  1
    max_players  2
    published_at Time.now

    after :create do |game|
      owner = FactoryGirl.create(:user)
      GameOwnership.create game: game, user: owner

      GameZip.create(game:     game,
                     user:     owner,
                     file_key: [Faker::Lorem.word, ".zip"].join,
                     file_last_modified: Time.now,
                     executable: [Faker::Lorem.word, ".exe"].join)

      Image.create(parent: game,
                   user: owner,
                   file_key: "screenshot.png",
                   parent_uuid: game.uuid)
    end
  end
end