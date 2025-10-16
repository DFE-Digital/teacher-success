class OneLoginSignInUser
  include Rails.application.routes.url_helpers

  # Sessions timeout after this period of inactivity
  SESSION_TIMEOUT = 2.hours

  attr_reader :email_address, :one_login_sign_in_uid, :id_token, :provider, :first_name, :last_name, :trn

  def initialize(email_address:, one_login_sign_in_uid:, first_name:, last_name:, id_token: nil, provider: nil, trn: nil)
    @email_address = email_address&.downcase
    @one_login_sign_in_uid = one_login_sign_in_uid
    @first_name = first_name
    @last_name = last_name
    @id_token = id_token
    @provider = provider&.to_s
    @trn = trn
  end

  # start a session from the OmniAuth payload
  def self.begin_session!(session, omniauth_payload)
    user_details = if ENV.fetch("SIGN_IN_METHOD", "") == "one-login-sign-in"
      token = omniauth_payload.dig("credentials", "token")
      TeacherAuth::Request::UserDetails.new(token).call
    else
      persona_trn_details
    end

    session["one_login_sign_in_user"] = {
      "email_address" => omniauth_payload.dig("info", "email"),
      "first_name" => omniauth_payload.dig("info", "first_name") || user_details.dig("firstName"),
      "last_name" => omniauth_payload.dig("info", "last_name") || user_details.dig("lastName"),
      "one_login_sign_in_uid" => omniauth_payload.dig("uid"),
      "last_active_at" => Time.current,
      "id_token" => omniauth_payload.dig("credentials", "id_token"),
      "provider" => omniauth_payload.dig("provider"),
      "trn" => user_details.dig("trn"),
      "training_details" => user_details.dig("routesToProfessionalStatuses")
    }

    session["one_login_sign_in_user"]
  end

  # load a user from the session, if valid & not expired
  def self.load_from_session(session)
    data = session["one_login_sign_in_user"]
    return unless data
    return unless data["last_active_at"]

    return if data["last_active_at"] < SESSION_TIMEOUT.ago

    data["last_active_at"] = Time.current

    new(
      email_address: data["email_address"],
      one_login_sign_in_uid: data["one_login_sign_in_uid"],
      first_name: data["first_name"],
      last_name: data["last_name"],
      id_token: data["id_token"],
      provider: data["provider"],
      trn: data["trn"],
    )
  end

  # clear the session
  def self.end_session!(session)
    session.clear
  end

  def user
    @user ||= begin
      one_login_user = User.find_by(one_login_sign_in_uid: one_login_sign_in_uid) ||
         User.find_by(email_address: email_address)
      return one_login_user if one_login_user.present?

      User.find_or_create_by!(
        one_login_sign_in_uid: one_login_sign_in_uid,
        first_name: first_name,
        last_name: last_name,
        email_address: email_address,
        trn: trn,
      )
    end
  end

  private

  def self.persona_trn_details
    training_details = {
      "routeToProfessionalStatusType" => {
        "routeToProfessionalStatusTypeId" => "123456789",
        "name" => "Provider led Postgrad",
        "professionalStatusType" => "QualifiedTeacherStatus"
      },
      "status" => "InTraining", "trainingStartDate" => "2001-01-01",
      "trainingEndDate" => "2001-04-04",
      "trainingSubjects" => [ { "reference" => "123456", "name" => "Maths With Computer Science" } ],
      "trainingAgeSpecialism" => { "type" => "KeyStage1" },
      "trainingProvider" => { "ukprn" => "123456789", "name" => "DfE University" },
      "degreeType" => { "degreeTypeId" => "123abc", "name" => "BSc" }
    }

    {
      "trn" => "1234567",
      "firstName" => "Joe",
      "middleName" => "",
      "lastName" => "Bloggs",
      "dateOfBirth" => "1990-01-01",
      "nationalInsuranceNumber" => "NI123",
      "emailAddress" => "user@example.com",
      "qts" => nil,
      "eyts" => nil,
      "routesToProfessionalStatuses" => [ training_details ],
      "qtlsStatus" => "None"
    }
  end
end
