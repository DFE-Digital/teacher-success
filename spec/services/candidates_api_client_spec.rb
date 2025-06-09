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
  let(:query) { { updated_since: Date.current - 1.year } }

  subject(:client) { described_class.new }

  describe "#candidates" do
    subject { client.candidates }

    context "when the API returns a successful response" do
      let(:response_body) { { data: candidates } }

      before do
        stub_request(:get, endpoint).with(
          headers: headers,
          query: query
        ).to_return(
          status: 200,
          body: response_body.to_json,
          headers: { 'Content-Type' => 'application/json' }
        )
      end

      it { is_expected.to be_a(CandidatesCollection) }
      it { is_expected.to match_array(candidates) }
    end

    context "when the API returns an error response" do
      let(:response_body) { { error: "Unauthorized" } }

      before do
        stub_request(:get, endpoint)
          .with(
            headers: headers,
            query: query
          ).to_return(
            status: 401,
            body: response_body.to_json,
            headers: { 'Content-Type' => 'application/json' }
          )
      end

      it "raises an error" do
        expect { subject }.to raise_error(StandardError, /Unauthorized/)
      end
    end
  end
end
