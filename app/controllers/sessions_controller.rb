class SessionsController < ApplicationController
  ONELOGIN_JWT_CORE_IDENTITY_HASH_KEY = "https://vocab.account.gov.uk/v1/coreIdentityJWT".freeze
  def new; end

  def callback
    # start session from OmniAuth payload
    OneLoginSignInUser.begin_session!(session, omniauth_hash)

    if current_user
      current_user.update!(last_signed_in_at: Time.current)

      redirect_to account_path
    else
      OneLoginSignInUser.end_session!(session)
      redirect_to root_path, flash: {
        heading: "Cannot sign in",
        success: false
      }
    end
  end

  def identify
    current_user.update!(
      first_name: user_details[:first_name],
      last_name: user_details[:last_name],
      date_of_birth: user_details[:date_of_birth],
    )

    redirect_to account_path
  end

  # def teacher_auth
  #   debugger
  # end

  def destroy
    _id_token = session.dig("one_login_sign_in_user", "id_token")
    OneLoginSignInUser.end_session!(session)

    redirect_to root_path
  end

  def failure
    one_login_sign_in_uid = session.dig("one_login_sign_in_user", "one_login_sign_in_uid")
    Rails.logger.warn("DSI failure with #{params[:message]} for one_login_sign_in_uid: #{one_login_sign_in_uid}")
    OneLoginSignInUser.end_session!(session)

    redirect_to internal_server_error_path, alert: "Sign-in failed"
  end

  private

  def logout_request(id_token)
    logout_utility.build_request(
      id_token_hint: id_token,
      post_logout_redirect_uri: ENV["GOVUK_ONE_LOGOUT_REDIRECT_URI"],
    )
  end

  def logout_utility
    OmniAuth::GovukOneLogin::LogoutUtility.new(end_session_endpoint: sign_out_path)
  end

  def omniauth_hash
    request.env.dig("omniauth.auth")
  end

  def user_details
    @user_details ||= begin
      token = omniauth_hash.extra.raw_info[ONELOGIN_JWT_CORE_IDENTITY_HASH_KEY]
      jwt_identity = OneLogin::CoreIdentityDecoded.new(jwt: token)
      jwt_identity.call
      {
        first_name: jwt_identity.first_name,
        last_name: jwt_identity.last_name,
        date_of_birth: jwt_identity.date_of_birth
      }
    end
  end
end
