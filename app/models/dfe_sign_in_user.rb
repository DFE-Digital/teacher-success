class DfESignInUser
  # Sessions timeout after this period of inactivity
  SESSION_TIMEOUT = 2.hours

  attr_reader :email_address, :dfe_sign_in_uid, :id_token, :provider, :first_name, :last_name

  def initialize(email_address:, dfe_sign_in_uid:, first_name:, last_name:, id_token: nil, provider: nil)
    @email_address = email_address&.downcase
    @dfe_sign_in_uid = dfe_sign_in_uid
    @first_name = first_name
    @last_name = last_name
    @id_token = id_token
    @provider = provider&.to_s
  end

  # start a session from the OmniAuth payload
  def self.begin_session!(session, omniauth_payload)
    session["dfe_sign_in_user"] = {
      "email_address" => omniauth_payload.dig("info", "email"),
      "dfe_sign_in_uid" => omniauth_payload["uid"],
      "first_name" => omniauth_payload.dig("info", "first_name"),
      "last_name" => omniauth_payload.dig("info", "last_name"),
      "last_active_at" => Time.current,
      "id_token" => omniauth_payload.dig("credentials", "id_token"),
      "provider" => omniauth_payload["provider"]
    }
  end

  # load a user from the session, if valid & not expired
  def self.load_from_session(session)
    data = session["dfe_sign_in_user"]
    return unless data
    return unless data["last_active_at"]

    return if data["last_active_at"] < SESSION_TIMEOUT.ago

    data["last_active_at"] = Time.current

    new(
      email_address: data["email_address"],
      dfe_sign_in_uid: data["dfe_sign_in_uid"],
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

  # fetch the actual User record from the database
  def user
    @user ||= begin
      def_user = User.find_by(dfe_sign_in_uid: dfe_sign_in_uid) ||
         User.find_by(email_address: email_address)
      return def_user if def_user.present?

      User.find_or_create_by!(
        dfe_sign_in_uid: dfe_sign_in_uid,
        first_name: first_name,
        last_name: last_name,
        email_address: email_address,
      ).tap do |new_user|
        # TRS does not have an API to get a user without knowing TRN or DOB
        # TRN 1234567 used for Proof of Concept
        if new_user.trn.blank?
          new_user.trn = TeachingRecordSystem::GetTeacher
             .new(trn: 1234567).call.dig("trn")
        end
      end
    end

  end

  # logout URL (DFE Sign-in or local dev)
  def logout_url(request)
    if signed_in_from_dfe?
      dfe_logout_url(request)
    else
      "/auth/developer/sign-out"
    end
  end

  private

  def signed_in_from_dfe?
    @provider == "dfe"
  end

  def dfe_logout_url(request)
    uri = URI("#{ENV["DFE_SIGN_IN_ISSUER_URL"]}/session/end")
    uri.query = {
      id_token_hint: @id_token,
      post_logout_redirect_uri: "#{request.base_url}/auth/dfe/sign-out"
    }.to_query
    uri.to_s
  end
end
