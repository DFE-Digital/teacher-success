class SessionsController < ApplicationController
  def new; end

  def callback
    # start session from OmniAuth payload
    OneLoginSignInUser.begin_session!(session, request.env.dig("omniauth.auth"))

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
    redirect_to root_path && return unless session.dig("onelogin_sign_in_user").present?

    id_token = session.dig("onelogin_sign_in_user","id_token")
    OneLoginSignInUser.end_session!(session)
    if ENV["SIGN_IN_METHOD"] == "dfe-sign-in"
      redirect_to(logout_request(id_token).redirect_uri, allow_other_host: true)
    else
      redirect_to root_path
    end
  end

  def failure
    dfe_sign_in_uid = session.dig("onelogin_sign_in_user", "onelogin_sign_in_uid")
    Rails.logger.warn("DSI failure with #{params[:message]} for dfe_sign_in_uid: #{dfe_sign_in_uid}")
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
end
