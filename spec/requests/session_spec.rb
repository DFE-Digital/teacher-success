require "rails_helper"

RSpec.describe "Sessions", type: :request do
  after do
    OmniAuth.config.mock_auth[:teacher_auth] = nil
  end

  let(:training_details) do
    {
      "routeToProfessionalStatusType" => { "routeToProfessionalStatusTypeId" => "97497716-5ac5-49aa-a444-27fa3e2c152a", "name" => "Provider led Postgrad", "professionalStatusType" => "QualifiedTeacherStatus" },
      "status" => "InTraining", "trainingStartDate" => "2001-01-01",
      "trainingEndDate" => "2001-04-04",
      "trainingSubjects" => [ { "reference" => "123456", "name" => "Maths With Computer Science" } ],
      "trainingAgeSpecialism" => { "type" => "KeyStage1" },
      "trainingProvider" => { "ukprn" => "123456789", "name" => "Birmingham City University" },
      "degreeType" => { "degreeTypeId" => "123abc", "name" => "BSc" }
    }
  end

  describe "GET /auth/teacher_auth/callback" do
    before do
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
          "token" => "abcd"
        }
      }

      OmniAuth.config.mock_auth[:teacher_auth] = OmniAuth::AuthHash.new(omniauth_payload)

      stub_teacher_auth_request(training_details)
    end

    it "signs the user in and redirects to root" do
      get "/auth/teacher_auth/callback"

      follow_redirect!

      expect(response).to have_http_status(:success)
      expect(response).to render_template("account/index")

      expect(session["one_login_sign_in_user"]).not_to be_nil
      expect(session.dig("one_login_sign_in_user", "one_login_sign_in_uid")).to eq("abcd")
      expect(session.dig("one_login_sign_in_user", "email_address")).to eq("user@example.com")
      expect(session.dig("one_login_sign_in_user", "first_name")).to eq("Joe")
      expect(session.dig("one_login_sign_in_user", "last_name")).to eq("Bloggs")
      expect(session.dig("one_login_sign_in_user", "provider")).to eq("teacher_auth")
      expect(session.dig("one_login_sign_in_user", "id_token")).to eq("1234")
      expect(session.dig("one_login_sign_in_user", "last_active_at")).not_to be_nil
      expect(session.dig("one_login_sign_in_user", "trn")).to eq("1234567")
      expect(session.dig("one_login_sign_in_user", "training_details")).to eq([ training_details ])
    ensure
      OmniAuth.config.mock_auth[:teacher_auth] = nil
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

  def stub_teacher_auth_request(training_details)
    request_body = { "trn" => "1234567",
                    "firstName" => "Joe",
                    "middleName" => "",
                    "lastName" => "Bloggs",
                    "dateOfBirth" => "1990-01-01",
                    "nationalInsuranceNumber" => "NI123",
                    "emailAddress" => "joe_bloggs@example.com",
                    "qts" => nil,
                    "eyts" => nil,
                    "routesToProfessionalStatuses" => [ training_details ],
                    "qtlsStatus" => "None" }
    stub_request(:get, "https://teacher_auth.gov.uk/person").
      to_return(status: 200, body: request_body.to_json, headers: {})
  end
end
