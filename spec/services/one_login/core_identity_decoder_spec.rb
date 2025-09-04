require "rails_helper"

RSpec.describe OneLogin::CoreIdentityDecoder do
  subject(:core_identity_decoder) { described_class.new(jwt:) }

  before do
    stub_one_login_did_request
    allow(JWT).to receive(:decode).and_return(decoded_jwt)
    allow(JWT::JWK).to receive(:new).and_return({})
    allow(JWT::JWK::Set).to receive(:new).and_return(
      {
        "kty" =>"kty-key",
        "crv" => "crv-key",
        "x" => "x-key",
        "y" => "y-key",
        "alg" => "ALG"
      }
    )
  end

  let(:jwt) { "12345" }
  let(:decoded_jwt) do
    [
      {
        "vc" => {
          "credentialSubject" => {
            "name" => [
              "nameParts" => [
                {
                  "type" => "GivenName",
                  "value" => "Joe"
                },
                {
                  "type" => "FamilyName",
                  "value" => "Bloggs"
                }
              ]
            ],
            "birthDate" => [
              "value" => "01/01/2001"
            ]
          }
        }
      }
    ]
  end

  describe "first_name" do
    it "returns the GivenName attribute of the decoded JWT" do
      expect(core_identity_decoder.first_name).to eq("Joe")
    end
  end

  describe "last_name" do
    it "returns the FamilyName attribute of the decoded JWT" do
      expect(core_identity_decoder.last_name).to eq("Bloggs")
    end
  end

  describe "date_of_birth" do
    it "returns the birthDate attribute of the decoded JWT" do
      expect(core_identity_decoder.date_of_birth).to eq(Date.parse("01/01/2001"))
    end
  end

  private

  def stub_one_login_did_request
    request_body = {
      "@context": %w[https://www.w3.org/ns/did/v1 https://w3id.org/security/jwk/v1],
      "id": "did:web:identity.integration.example.gov.uk",
      "assertionMethod": [
        {
          "type": "JsonWebKey",
          "id": "did:web:integration.example.gov.uk#123456",
          "controller": "did:web:integration.example.gov",
          "publicKeyJwk": {
            "kty": "kty-key",
            "crv": "crv-key",
            "x": "x-key",
            "y": "y-key",
            "alg": "ALG"
          }
        }
      ]
    }
    stub_request(:get, "https://integration.example.gov.uk/.well-known/did.json").
      to_return(status: 200, body: request_body.to_json, headers: {})
  end
end
