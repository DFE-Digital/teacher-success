# spec/models/candidates_collection_spec.rb
require "rails_helper"

RSpec.describe CandidatesCollection do
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

  subject(:collection) { described_class.new(candidates) }

  describe "#each" do
    it "yields each candidate" do
      results = []
      collection.each { |c| results << c }

      expect(results).to eq(candidates)
    end
  end

  describe "#with_application_status" do
    subject(:filtered_collection) { collection.with_application_status(statuses: statuses) }

    let(:statuses) { [ "recruited" ] }

    it "includes candidates with a matching application status" do
      expect(filtered_collection).to contain_exactly(candidate_1)
    end

    context "when no application_forms are present" do
      let(:candidates) do
        [
          { "id" => 3, "attributes" => {} }
        ]
      end

      it "returns an empty collection" do
        expect(filtered_collection.to_a).to be_empty
      end
    end
  end

  describe "#with_recruitment_cycle_year" do
    subject(:filtered_collection) { collection.with_recruitment_cycle_year(year: year) }

    let(:year) { 2024 }

    it "includes candidates with a matching recruitment cycle year" do
      expect(filtered_collection).to contain_exactly(candidate_2)
    end

    context "when application_forms is missing" do
      let(:candidates) do
        [
          { "id" => 3, "attributes" => {} }
        ]
      end

      it "returns an empty collection" do
        expect(filtered_collection.to_a).to be_empty
      end
    end
  end
end
