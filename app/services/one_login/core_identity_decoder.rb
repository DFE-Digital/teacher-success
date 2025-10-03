module OneLogin
  class CoreIdentityDecoder
    attr_reader :jwt
    def initialize(jwt:)
      @jwt = jwt
    end

    def first_name
      name_parts.find { |part| part["type"] == "GivenName" }["value"]
    end

    def last_name
      name_parts.find { |part| part["type"] == "FamilyName" }["value"]
    end

    def date_of_birth
      Date.parse(decoded_jwt[0]["vc"]["credentialSubject"]["birthDate"][0]["value"])
    end

    private

    def decoded_jwt
      @decoded_jwt ||= JWT.decode(jwt, nil, true, algorithms:, jwks:)
    end

    def name_parts
      decoded_jwt[0]["vc"]["credentialSubject"]["name"][0]["nameParts"]
    end

    def algorithms
      one_login_did.algorithms
    end

    def jwks
      one_login_did.jwks
    end

    def one_login_did
      @one_login_did ||= OneLogin::Did.new
    end
  end
end
