FactoryGirl.define do
  factory :user do
    name  { Faker::Name.name }
    email { Faker::Internet.email }
    password { Faker::Internet.password }
    admin false

    factory :admin do
      admin true
    end

    factory :builder do
      builder true
    end
  end
end
