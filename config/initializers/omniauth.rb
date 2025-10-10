OmniAuth.config.logger = Rails.logger

case ENV.fetch("SIGN_IN_METHOD", "persona")
when "persona"
  # For local development
  Rails.application.config.middleware.use OmniAuth::Builder do
    provider(
      :developer,
      fields: %i[uid email first_name last_name],
      uid_field: :uid,
    )
  end

when "one-login-sign-in"
  Rails.application.config.middleware.use OmniAuth::Builder do
    provider :openid_connect, {
      name: :teacher_auth,
      allow_authorize_params: %i[session_id],
      callback_path: "/auth/teacher_auth/callback",
      send_scope_to_token_endpoint: false,
      client_options: {
        authorization_endpoint: "/oauth2/authorize",
        end_session_endpoint: "/oauth2/logout",
        token_endpoint: "/oauth2/token",
        userinfo_endpoint: "/oauth2/userinfo",
        host: URI(ENV.fetch("TEACHER_AUTH_BASE_URL", "")).host,
        port: 443,
        identifier: ENV["TEACHER_AUTH_CLIENT_ID"],
        redirect_uri: ENV["TEACHER_AUTH_REDIRECT_URI"],
        jwks_uri: ENV["TEACHER_AUTH_JWKS_URI"],
        secret: ENV["TEACHER_AUTH_SECRET"],
        scheme: "https"
      },
      scope: [ "teaching_record", "email" ],
      discovery: true,
      issuer:  ENV["TEACHER_AUTH_BASE_URL"],
      pkce: true,
      response_type: :code
    }

    # will call `Users::OmniauthController#failure` if there are any errors during the login process
    on_failure { |env| SessionsController.action(:failure).call(env) }
  end
end
