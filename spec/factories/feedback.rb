FactoryBot.define do
  factory :feedback do
    rating { :satisfied }
    topic { :site }
    description { "Great!" }
    can_contact { false }

    trait :with_contact_details do
      can_contact { true }
      sequence(:email) { |n| "user_#{n}@example.com" }
    end
  end
end
