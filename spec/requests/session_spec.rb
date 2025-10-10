require "rails_helper"

RSpec.describe "Sessions", type: :request do
  after do
    OmniAuth.config.mock_auth[:govuk_one_login] = nil
    OmniAuth.config.mock_auth[:govuk_one_login_identify] = nil
  end

  describe "GET /auth/onelogin/callback" do
    before do
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
    end

    it "signs the user in and redirects to root" do
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

  describe "GET /auth/govuk_one_login/identify" do
    let(:first_name) { "Joe" }
    let(:last_name) { "Bloggs" }
    let(:date_of_birth) { Date.parse("2001-01-01") }
    let(:current_user) { create(:user, email_address: "user@example.com") }
    let(:mock_core_identifier) do
      instance_double(OneLogin::CoreIdentityDecoder).tap do |mock_core_identifier|
        allow(mock_core_identifier).to receive(:first_name).and_return(first_name)
        allow(mock_core_identifier).to receive(:last_name).and_return(last_name)
        allow(mock_core_identifier).to receive(:date_of_birth).and_return(date_of_birth)
      end
    end

    before do
      omniauth_hash = {
        extra: {
          raw_info: {
            "https://vocab.account.gov.uk/v1/coreIdentityJWT" => "1234"
          }
        }
      }
      OmniAuth.config.mock_auth[:govuk_one_login_identify] = OmniAuth::AuthHash.new(omniauth_hash)

      allow(OneLogin::CoreIdentityDecoder).to receive(:new).and_return(mock_core_identifier)
      allow(OneLoginSignInUser).to receive(:load_from_session).and_return(
        OneLoginSignInUser.new(email_address: current_user.email_address, one_login_sign_in_uid: "1234")
      )
    end

    it "updates the user's first_name, last_name, and date_of_birth attributes with the data from OneLogin" do
      get "/auth/govuk_one_login/identify"

      follow_redirect!

      expect(response).to have_http_status(:success)
      expect(response).to render_template("account/index")

      current_user.reload
      expect(current_user.first_name).to eq("Joe")
      expect(current_user.last_name).to eq("Bloggs")
      expect(current_user.date_of_birth).to eq(date_of_birth)
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
