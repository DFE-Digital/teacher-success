class AccountController < ApplicationController
  def index
    @training_details = session.dig("one_login_sign_in_user", "training_details")
  end
end
