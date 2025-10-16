class SupportRequest < ApplicationRecord
  validates :name, presence: { message: "Please enter a name" }
  validates :email, presence: { message: "Please enter an email" },
            format: { with: URI::MailTo::EMAIL_REGEXP, message: "Please enter a valid email address" }
  validates :problem, presence: { message: "Please enter the problem you are experiencing" }
  validates :area_of_website_url, presence: { message: "Please enter a valid URL" }, if: -> { area_of_website == "specific_page" }

  enum :area_of_website, {
    whole_site: "whole_site",
    specific_page: "specific_page"
  }, validate: { message: "Please select an area of the website" }
end
