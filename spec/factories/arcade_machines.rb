FactoryBot.define do
  factory :arcade_machine do
    title    { Faker::Lorem.words(3).join(" ") }
    location "New York, NY"
    players  2
    mappable true

    after :create do |machine|
      ApiKey.create arcade_machine: machine
      MachineOwnership.create arcade_machine: machine, user: FactoryBot.create(:user)
      ApprovalRequest.create approvable: machine, approved_at: Time.now.utc
    end
  end
end