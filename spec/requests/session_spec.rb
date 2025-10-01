require "rails_helper"

RSpec.describe "Sessions", type: :request do
  describe "GET /auth/onelogin/callback" do
    after do
      OmniAuth.config.mock_auth[:govuk_one_login] = nil
    end

    it "signs the user in and redirects to root" do
      user = {
        email_address: "user@example.com",
        onelogin_sign_in_uid: "abcd",
        last_active_at: Time.current,
        id_token: "1234",
        provider: "one_login"
      }

      # simulate the OmniAuth payload
      omniauth_hash = {
        "provider" => "govuk_one_login",
        "uuid" => user[:onelogin_sign_in_uid],
        "info" => {
          "email" => user[:email_address],
          "uuid" => user[:onelogin_sign_in_uid]
        },
        "credentials" => {
          "id_token" => "1234"
        }
      }

      OmniAuth.config.mock_auth[:govuk_one_login] = OmniAuth::AuthHash.new(omniauth_hash)

      get "/auth/govuk_one_login/callback"

      follow_redirect!

      expect(response).to have_http_status(:success)
      expect(response).to render_template("account/index")

      expect(session["one_login_sign_in_user"]).not_to be_nil
      expect(session.dig("one_login_sign_in_user", "one_login_sign_in_uid")).to eq("abcd")
      expect(session.dig("one_login_sign_in_user", "email_address")).to eq("user@example.com")
      expect(session.dig("one_login_sign_in_user", "provider")).to eq("govuk_one_login")
      expect(session.dig("one_login_sign_in_user", "id_token")).to eq("1234")
      expect(session.dig("one_login_sign_in_user", "last_active_at")).not_to be_nil
    ensure
      OmniAuth.config.mock_auth[:govuk_one_login] = nil
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
