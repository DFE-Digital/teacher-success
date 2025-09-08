require "rails_helper"

RSpec.describe "Sessions", type: :request do
  describe "GET /auth/dfe/callback" do
    after do
      OmniAuth.config.mock_auth[:dfe] = nil
    end

    it "signs the user in and redirects to root" do
      user = {
        dfe_sign_in_uid: "123",
        email_address: "user@example.com",
        first_name: "Test",
        last_name: "User",
      }

      # simulate the OmniAuth payload
      omniauth_hash = {
        "provider" => "dfe",
        "uid" => user[:dfe_sign_in_uid],
        "info" => {
          "email" => user[:email_address],
          "first_name" => user[:first_name],
          "last_name" => user[:last_name],
        },
        "credentials" => {
          "id_token" => "abc"
        }
      }

      OmniAuth.config.mock_auth[:dfe] = OmniAuth::AuthHash.new(omniauth_hash)

      get "/auth/dfe/callback"

      follow_redirect!

      expect(response).to have_http_status(:success)
      expect(response).to render_template("account/index")

      expect(session["dfe_sign_in_user"]).not_to be_nil
      expect(session.dig("dfe_sign_in_user", "dfe_sign_in_uid")).to eq("123")
      expect(session.dig("dfe_sign_in_user", "email_address")).to eq("user@example.com")
      expect(session.dig("dfe_sign_in_user", "first_name")).to eq("Test")
      expect(session.dig("dfe_sign_in_user", "last_name")).to eq("User")
    ensure
      OmniAuth.config.mock_auth[:dfe] = nil
    end
  end

  describe "GET /auth/failure" do
    it "redirects to internal server error page" do
      get "/auth/failure", params: { message: "access_denied" }

      follow_redirect!

      expect(response).to have_http_status(:internal_server_error)

      expect(response).to render_template("errors/internal_server_error")
    end
  end
end
