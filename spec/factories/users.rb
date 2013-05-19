FactoryGirl.define do
  factory :user do
    name 'John'
    email
    password 'my_password'
    password_confirmation 'my_password'
    # required if the Devise Confirmable module is used
    confirmed_at Time.now
  end
end

FactoryGirl.define do
  sequence :email do |n|
    "john.snow#{n}@example.com"
  end
end