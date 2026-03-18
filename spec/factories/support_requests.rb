FactoryBot.define do
  factory :support_request do
    name { "Joe Bloggs" }
    email { "joe_bloggs@example.com" }
    problem { "500 Error" }
    area_of_website { "whole_site" }
  end
end
