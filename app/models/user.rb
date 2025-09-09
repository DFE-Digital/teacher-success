class User < ApplicationRecord
  validates :first_name, :last_name, presence: true
  validates :email_address, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP, message: "Please enter a valid email address" }
end
