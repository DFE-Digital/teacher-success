module OneLogin
  class Did
    def context
      @context ||= document_hash["@context"]
    end

    def id
      @id ||= document_hash["id"]
    end

    def assertion_methods
      @assertion_methods ||= document_hash["assertionMethod"]
    end

    def algorithms
      @algorithms ||= assertion_methods.map do |assertion|
        assertion.dig("publicKeyJwk", "alg")
      end
    end

    def jwks
      return @jwks if @jwks

      keys = assertion_methods.map do |assertion|
        jwk = JWT::JWK.new(assertion["publicKeyJwk"])
        jwk[:kid] = assertion["id"]
        jwk
      end

      @jwks = JWT::JWK::Set.new(keys)
    end

    private

    def document_hash
      @document_hash ||= begin
                           response = HTTParty.get(ENV.fetch("GOVUK_ONE_LOGIN_DID_URL", ""))
                           JSON.parse(response.body)
                         end
    end
  end
end
