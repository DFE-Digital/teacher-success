FactoryBot.define do
  factory :page_feedback do
    useful { false }
    feedback { "MyText" }
    url { "MyString" }
  end
end
