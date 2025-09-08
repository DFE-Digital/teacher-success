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

when "dfe-sign-in"
  dfe_sign_in_issuer_uri = URI(ENV.fetch("DFE_SIGN_IN_ISSUER_URL"))
  dfe_sign_in_redirect_uri = "#{ENV.fetch("APP_BASE_URL")}/auth/dfe/callback"

  Rails.application.config.middleware.use OmniAuth::Builder do
    provider :openid_connect, {
      name: :dfe,
      discovery: true,
      scope: %i[email profile],
      response_type: :code,
      path_prefix: "/auth",
      callback_path: "/auth/dfe/callback",
      issuer: "#{dfe_sign_in_issuer_uri}",

      client_options: {
        port: dfe_sign_in_issuer_uri.port,
        scheme: dfe_sign_in_issuer_uri.scheme,
        host: dfe_sign_in_issuer_uri.host,
        identifier: ENV.fetch("DFE_SIGN_IN_CLIENT_ID"),
        secret: ENV.fetch("DFE_SIGN_IN_SECRET"),
        redirect_uri: dfe_sign_in_redirect_uri
      }
    }
  end
end
