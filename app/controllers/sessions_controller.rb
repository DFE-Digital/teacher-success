class SessionsController < ApplicationController
  def new; end

  def callback
    # start session from OmniAuth payload
    DfESignInUser.begin_session!(session, request.env["omniauth.auth"])

    if current_user
      redirect_to account_path
    else
      DfESignInUser.end_session!(session)
      redirect_to after_sign_out_path, flash: {
        heading: "Cannot sign in",
        success: false
      }
    end
  end

  def destroy
    # end session and redirect to root path. Should be expanded to conditionally head to dfe sign out path in future.
    DfESignInUser.end_session!(session)
    redirect_to root_path
  end

  def failure
    dfe_sign_in_uid = session.dig("dfe_sign_in_user", "dfe_sign_in_uid")
    Rails.logger.warn("DSI failure with #{params[:message]} for dfe_sign_in_uid: #{dfe_sign_in_uid}")
    DfESignInUser.end_session!(session)

    redirect_to main_app.internal_server_error_path, alert: "Sign-in failed"
  end
end
