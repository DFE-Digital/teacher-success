require "rails_helper"

describe OneLoginSignInUser do
  describe ".begin_session!" do
    it "creates a new session with DfE user details" do
      Timecop.freeze do
        session = {}
        user = {
          email_address: "user@example.com",
          onelogin_sign_in_uid: "abcd",
          last_active_at: Time.current,
          id_token: "1234",
          provider: "one_login"
        }

        # simulate the OmniAuth payload
        omniauth_payload = {
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

        described_class.begin_session!(session, omniauth_payload)

        expect(session).to eq(
           "one_login_sign_in_user" => {
             "email_address" => "user@example.com",
             "one_login_sign_in_uid" => "abcd",
             "last_active_at" => Time.current,
             "id_token" => "1234",
             "provider" => "govuk_one_login"
           }
         )
      end
    end
  end

  describe ".load_from_session" do
    it "returns a OneLoginSignInUser with details from the session" do
      session = {
        "one_login_sign_in_user" => {
          "email_address" => "user@example.com",
          "one_login_sign_in_uid" => "abcd",
          "last_active_at" => Time.current,
          "id_token" => "1234",
          "provider" => "govuk_one_login"
        }
      }

      one_login_sign_in_user = described_class.load_from_session(session)

      expect(one_login_sign_in_user).not_to be_nil
      expect(one_login_sign_in_user.email_address).to eq("user@example.com")
      expect(one_login_sign_in_user.one_login_sign_in_uid).to eq("abcd")
      expect(one_login_sign_in_user.id_token).to eq("1234")
      expect(one_login_sign_in_user.provider).to eq("govuk_one_login")
    end

    it "returns nil if session is expired" do
      session = {
        "one_login_sign_in_user" => {
          "last_active_at" => 3.hours.ago
        }
      }

      expect(described_class.load_from_session(session)).to be_nil
    end
  end

  describe ".end_session!" do
    it "clears the session" do
      session = {
        "one_login_sign_in_user" => {
          "email_address" => "user@example.com",
          "one_login_sign_in_uid" => "abcd",
          "last_active_at" => Time.current,
          "id_token" => "1234",
          "provider" => "govuk_one_login"
        }
      }

      described_class.end_session!(session)

      expect(session).to eq({})
    end
  end

  describe "#user" do

  end
end
