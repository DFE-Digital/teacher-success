require "rails_helper"

RSpec.describe OneLogin::Did do
  subject(:did) { described_class.new }

  before do
    stub_one_login_did_request
  end

  describe "#context" do
    it "returns the context of the DID request json" do
      expect(did.context).to contain_exactly("https://www.w3.org/ns/did/v1", "https://w3id.org/security/jwk/v1")
    end
  end

  describe "#id" do
    it "returns the id of the DID request json" do
      expect(did.id).to eq("did:web:identity.integration.example.gov.uk")
    end
  end

  describe "#assertion_methods" do
    it "returns the assertionMethod of the DID request json" do
      expect(did.assertion_methods).to match_array(
        [
          {
            "type" => "JsonWebKey",
            "id" => "did:web:integration.example.gov.uk#123456",
            "controller" => "did:web:integration.example.gov",
            "publicKeyJwk" => {
              "kty" =>"kty-key",
              "crv" => "crv-key",
              "x" => "x-key",
              "y" => "y-key",
              "alg" => "ALG"
            }
          }
       ]
      )
    end
  end

  describe "#algorithms" do
    it "returns the algorithms of the DID request json" do
      expect(did.algorithms).to contain_exactly("ALG")
    end
  end

  describe "#jwks" do
    before do
      allow(JWT::JWK).to receive(:new).and_return({})
      allow(JWT::JWK::Set).to receive(:new).and_return({
        "kty" =>"kty-key",
        "crv" => "crv-key",
        "x" => "x-key",
        "y" => "y-key",
        "alg" => "ALG"
      })
    end

    it "returns the publicKeyJwks of the DID request json" do
      expect(did.jwks).to contain_exactly(
        [ "alg", "ALG" ], [ "crv", "crv-key" ], [ "kty", "kty-key" ], [ "x", "x-key" ], [ "y", "y-key" ],
      )
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
