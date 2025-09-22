FactoryBot.define do
  factory :page_modification do
    path { "test" }
    content_hash { "123456789abc" }
  end
end
