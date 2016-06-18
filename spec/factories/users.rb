FactoryGirl.define do
  factory :user do
    name  { Faker::Name.name }
    email { Faker::Internet.email }
    password { Faker::Internet.password }
    admin false

    factory :admin do
      admin true
    end
  end
end
