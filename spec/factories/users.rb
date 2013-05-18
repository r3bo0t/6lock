FactoryGirl.define do
  factory :user do
    name 'John'
    email 'john.snow@example.com'
    password 'my_password'
    password_confirmation 'my_password'
    # required if the Devise Confirmable module is used
    confirmed_at Time.now
  end
end