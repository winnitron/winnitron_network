FactoryBot.define do
  factory :game do
    title        { Faker::Lorem.words(4).join(" ") }
    description  { Faker::Lorem.sentence(2) }
    min_players  { 1 }
    max_players  { 2 }
    users        { [FactoryBot.build(:user)] }

    after :create do |game|
      GameZip.create(game:     game,
                     user:     game.users.first,
                     file_key: [Faker::Lorem.word, ".zip"].join,
                     file_last_modified: Time.now.utc,
                     executable: [Faker::Lorem.word, ".exe"].join)

      ApiKey.create parent: game

      game.update published_at: Time.now
    end
  end
end