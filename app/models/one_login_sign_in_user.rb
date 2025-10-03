class OneLoginSignInUser
  include Rails.application.routes.url_helpers

  # Sessions timeout after this period of inactivity
  SESSION_TIMEOUT = 2.hours

  attr_reader :email_address, :one_login_sign_in_uid, :id_token, :provider, :first_name, :last_name

  def initialize(email_address:, one_login_sign_in_uid:, first_name: nil, last_name: nil, id_token: nil, provider: nil)
    @email_address = email_address&.downcase
    @one_login_sign_in_uid = one_login_sign_in_uid
    @first_name = first_name
    @last_name = last_name
    @id_token = id_token
    @provider = provider&.to_s
  end

  # start a session from the OmniAuth payload
  def self.begin_session!(session, omniauth_payload)
    session["one_login_sign_in_user"] = {
      "email_address" => omniauth_payload.dig("info", "email"),
      "one_login_sign_in_uid" => omniauth_payload.dig("info", "uuid"),
      "last_active_at" => Time.current,
      "id_token" => omniauth_payload.dig("credentials", "id_token"),
      "provider" => omniauth_payload["provider"]
    }
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
      )
    end
  end
end
