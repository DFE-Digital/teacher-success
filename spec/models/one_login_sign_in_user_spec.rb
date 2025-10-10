require "rails_helper"

describe OneLoginSignInUser do
  describe ".begin_session!" do
    before do
      stub_teacher_auth_request
    end

    it "creates a new session with Teacher Auth/One Login user details" do
      Timecop.freeze do
        session = {}
        user = {
          email_address: "user@example.com",
          onelogin_sign_in_uid: "abcd",
          last_active_at: Time.current,
          id_token: "1234",
          provider: "teacher_auth"
        }

        # simulate the OmniAuth payload
        omniauth_payload = {
          "provider" => "teacher_auth",
          "uid" => user[:onelogin_sign_in_uid],
          "info" => {
            "email" => user[:email_address],
            "uuid" => user[:onelogin_sign_in_uid]
          },
          "credentials" => {
            "id_token" => "1234",
            "token" => "abcd",
          }
        }

        described_class.begin_session!(session, omniauth_payload)

        expect(session).to eq(
           "one_login_sign_in_user" => {
             "email_address" => "user@example.com",
             "one_login_sign_in_uid" => "abcd",
             "first_name" => "Joe",
             "last_name" => "Bloggs",
             "last_active_at" => Time.current,
             "id_token" => "1234",
             "provider" => "teacher_auth",
             "trn" => "1234567",
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
          "first_name" => "Joe",
          "last_name" => "Bloggs",
          "one_login_sign_in_uid" => "abcd",
          "last_active_at" => Time.current,
          "id_token" => "1234",
          "provider" => "teacher_auth",
          "trn" => "1234567",
        }
      }

      one_login_sign_in_user = described_class.load_from_session(session)

      expect(one_login_sign_in_user).not_to be_nil
      expect(one_login_sign_in_user.email_address).to eq("user@example.com")
      expect(one_login_sign_in_user.first_name).to eq("Joe")
      expect(one_login_sign_in_user.last_name).to eq("Bloggs")
      expect(one_login_sign_in_user.one_login_sign_in_uid).to eq("abcd")
      expect(one_login_sign_in_user.id_token).to eq("1234")
      expect(one_login_sign_in_user.provider).to eq("teacher_auth")
      expect(one_login_sign_in_user.trn).to eq("1234567")
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
    subject(:user) do
      described_class.new(
        email_address:,
        one_login_sign_in_uid:,
        first_name:,
        last_name:,
      ).user
    end

    let(:first_name) { "Joe" }
    let(:last_name) { "Bloggs" }
    let(:one_login_sign_in_uid) { "1234" }
    let(:email_address) { "user@example.com" }

    context "when a user does not exist" do
      it "creates a new user" do
        expect { user }.to change(User, :count).by(1)
        new_user = user
        expect(new_user.first_name).to eq(first_name)
        expect(new_user.last_name).to eq(last_name)
        expect(new_user.email_address).to eq(email_address)
        expect(new_user.one_login_sign_in_uid).to eq(one_login_sign_in_uid)
      end
    end

    context "when a user exists" do
      let(:existing_user) do
        create(
          :user,
          first_name:,
          last_name:,
          email_address:,
          one_login_sign_in_uid: sign_in_uid,
        )
      end

      before { existing_user }

      context "when the user's one_login_sign_in_uid is different" do
        let(:sign_in_uid) { "abcd" }

        it "returns the existing user" do
          expect(user).to eq(existing_user)
        end
      end

      context "when the user's one_login_sign_in_uid the same" do
        let(:sign_in_uid) { one_login_sign_in_uid }

        it "returns the existing user" do
          expect(user).to eq(existing_user)
        end
      end
    end
  end

  private

  def stub_teacher_auth_request
    request_body = {"trn" => "1234567",
                    "firstName" => "Joe",
                    "middleName" => "",
                    "lastName" => "Bloggs",
                    "dateOfBirth" => "1990-01-01",
                    "nationalInsuranceNumber" => "NI123",
                    "emailAddress" => "user@example.com",
                    "qts" => nil,
                    "eyts" => nil,
                    "routesToProfessionalStatuses" => [],
                    "qtlsStatus" => "None"}
    stub_request(:get, "https://teacher_auth.gov.uk/person").
      to_return(status: 200, body: request_body.to_json, headers: {})
  end
end
