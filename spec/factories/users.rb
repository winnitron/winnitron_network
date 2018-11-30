FactoryBot.define do
  factory :user do
    name  { Faker::Name.name }
    email { Faker::Internet.email }
    password { Faker::Internet.password }
    admin { false }

    factory :admin do
      admin { true }
    end

    factory :builder do
      after :create do |user|
        machine = FactoryBot.create(:arcade_machine)
        user.arcade_machines << machine
      end
    end
  end
end
