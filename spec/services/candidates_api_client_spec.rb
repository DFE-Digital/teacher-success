require "rails_helper"

RSpec.describe CandidatesApiClient do
  let(:candidate_1) do
    {
      "id" => 1,
      "attributes" => {
        "application_forms" => [ {
          "application_status" => "recruited",
          "recruitment_cycle_year" => 2025
        } ]
      }
    }
  end

  let(:candidate_2) do
    {
      "id" => 2,
      "attributes" => {
        "application_forms" => [ {
          "application_status" => "withdrawn",
          "recruitment_cycle_year" => 2024
        } ]
      }
    }
  end

  let(:candidates) { [ candidate_1, candidate_2 ] }

  let(:endpoint) { "#{ENV["CANDIDATE_API_BASE_URI"]}/candidates" }
  let(:headers) { { "Authorization" => "Bearer #{ENV["CANDIDATE_API_ACCESS_TOKEN"]}" } }
  let(:query) { { page: 1, per_page: 500, updated_since: Date.current - 1.year } }

  subject(:client) { described_class.new }

  describe "#candidates" do
    subject { client.candidates(query: query) }

    before do
      stub_request(:get, endpoint).with(
        headers: headers,
        query: query
      ).to_return(
        status: status,
        body: response_body.to_json,
        headers: { 'Content-Type' => 'application/json' }
      )
    end

    context "when the API returns a successful response" do
      let(:status) { 200 }
      let(:response_body) { { data: candidates } }

      it { is_expected.to be_a(CandidatesCollection) }
      it { is_expected.to match_array(candidates) }
    end

    context "when the API returns an non-specific error response" do
      let(:status) { 401 }
      let(:response_body) { { error: "Unauthorized" } }

      it "raises an error" do
        expect { subject }.to raise_error(StandardError, /Unauthorized/)
      end
    end

    context "when the API returns a ParameterMissing response" do
      let(:query) { { page: 2 } }
      let(:status) { 500 }
      let(:response_body) { { error: "ParameterMissing" } }

      it "raises an error" do
        expect { subject }.to raise_error(ParameterMissingError)
      end
    end

    context "when the API returns a PageParameterInvalid response" do
      let(:query) { { page: 9999 } }
      let(:status) { 500 }
      let(:response_body) { { error: "PageParameterInvalid" } }

      it "raises an error" do
        expect { subject }.to raise_error(PageParameterInvalidError)
      end
    end
  end
end
