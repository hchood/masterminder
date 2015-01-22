FactoryGirl.define do
  factory :task do
    project

    sequence(:name) { |n| "#{n} - Assemble minions" }
  end
end
