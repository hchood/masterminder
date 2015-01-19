FactoryGirl.define do
  factory :user do
    first_name "Faizaan"
    last_name "The Wizard"
    sequence(:email) { |n| "#{n}_faizaan@nefariousschemers.com" }
    password "secretpassword"
    bio "I am an evil schemer."
  end
end
