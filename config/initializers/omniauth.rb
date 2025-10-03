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
    private_key = begin
                    OpenSSL::PKey::RSA.new(ENV.fetch("GOVUK_ONE_LOGIN_PRIVATE_KEY", "").gsub("\\n", "\n"))
                  rescue OpenSSL::PKey::RSAError
                    nil
                  end
    provider :openid_connect, {
      name: :govuk_one_login,
      callback_path: "/auth/govuk_one_login/callback",
      client_auth_method: "jwt_bearer",
      client_options: {
        host:  ENV["GOVUK_ONE_LOGIN_BASE_URL"],
        identifier: ENV["GOVUK_ONE_LOGIN_CLIENT_ID"],
        redirect_uri: ENV["GOVUK_ONE_LOGIN_REDIRECT_URI"],
        secret: private_key
      },
      discovery: true,
      response_type: :code,
      scope: %i[openid email phone],
      send_scope_to_token_endpoint: false,
      issuer: ENV["GOVUK_ONE_LOGIN_BASE_URL"]
    }

    provider :openid_connect, {
      name: :govuk_one_login_identity,
      callback_path: "/auth/govuk_one_login/identify",
      client_auth_method: "jwt_bearer",
      client_options: {
        host:  ENV["GOVUK_ONE_LOGIN_BASE_URL"],
        identifier: ENV["GOVUK_ONE_LOGIN_CLIENT_ID"],
        redirect_uri: ENV["GOVUK_ONE_LOGIN_IDENTIFY_REDIRECT_URI"],
        secret: private_key
      },
      discovery: true,
      response_type: :code,
      scope: %i[openid email phone],
      send_scope_to_token_endpoint: false,
      issuer: ENV["GOVUK_ONE_LOGIN_BASE_URL"],
      extra_authorize_params: {
        vtr: '["Cl.Cm.P2"]',
        claims: { userinfo: { "https://vocab.account.gov.uk/v1/coreIdentityJWT": nil, "https://vocab.account.gov.uk/v1/returnCode": nil } }.to_json
      }
    }

    provider :openid_connect, {
      name: :teacher_auth,
      allow_authorize_params: %i[session_id trn_token],
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
      scope: [ "teaching_record" ],
      discovery: true,
      issuer:  ENV["TEACHER_AUTH_BASE_URL"],
      pkce: true,
      response_type: :code
    }

    # will call `Users::OmniauthController#failure` if there are any errors during the login process
    on_failure { |env| SessionsController.action(:failure).call(env) }
  end
end
