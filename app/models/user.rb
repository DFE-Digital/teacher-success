class User < ApplicationRecord
  validates :email_address, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP, message: "Please enter a valid email address" }
end
