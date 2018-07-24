FactoryBot.define do
  factory :arcade_machine do
    title    { Faker::Lorem.words(3).join(" ") }
    location
    players  2
    mappable true

    after :create do |machine|
      ApiKey.create arcade_machine: machine
      MachineOwnership.create arcade_machine: machine, user: FactoryBot.create(:user)
      ApprovalRequest.create approvable: machine, approved_at: Time.now.utc
    end
  end

  factory :location do
    address   { Faker::Address.street_address }
    city      { Faker::Address.city }
    state     { Faker::Address.state }
    country   { Faker::Address.country }
    latitude  { Faker::Address.latitude }
    longitude { Faker::Address.latitude }
  end
end