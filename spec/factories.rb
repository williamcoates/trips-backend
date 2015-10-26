FactoryGirl.define do

  factory :user do
    email { Faker::Internet.email }
    password "password"
    password_confirmation "password"
    confirmed_at Date.today
  end

  factory :admin, parent: :user do
    access_level :admin
  end

  factory :trip do
    destination { Faker::Address.city }
    start_date { Faker::Date.backward(30) }
    end_date { Faker::Date.forward(30) }
    comment { Faker::Lorem.sentence }
    user
  end
end
