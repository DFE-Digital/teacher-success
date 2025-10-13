class SessionsController < ApplicationController
  ONELOGIN_JWT_CORE_IDENTITY_HASH_KEY = "https://vocab.account.gov.uk/v1/coreIdentityJWT".freeze
  def new; end

  def callback
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

  def omniauth_hash
    request.env.dig("omniauth.auth")
  end
end
