require "rails_helper"
require "csv"
require "tempfile"

RSpec.describe AudienceGenerator do
  let(:candidate_1) do
    {
      "id" => "1",
      "attributes" => {
        "email_address" => "jane@example.com",
        "application_forms" => [
          {
            "first_name" => "Jane",
            "last_name" => "Doe",
            "recruitment_cycle_year" => 2024,
            "application_status" => "recruited"
          }
        ]
      }
    }
  end

  let(:candidate_2) do
    {
      "id" => "2",
      "attributes" => {
        "email_address" => "john@example.com",
        "application_forms" => [
          {
            "first_name" => "John",
            "last_name" => "Smith",
            "recruitment_cycle_year" => 2024,
            "application_status" => "pending_conditions"
          }
        ]
      }
    }
  end

  let(:candidates) { [ candidate_1, candidate_2 ] }

  describe "#export" do
    let(:file) { Tempfile.new("audience.csv") }
    let(:filepath) { file.path }

    subject! { described_class.new(filepath: filepath, data: candidates).export }

    after do
      file.close
      file.unlink
    end

    it "writes the correct headers and candidate data to the CSV file" do
      content = File.read(filepath)
      csv = CSV.parse(content, headers: true)

      expect(csv.headers).to contain_exactly(
        "id", "email", "first_name", "last_name", "recruitment_cycle_year", "application_status"
      )

      expect(csv.length).to eq(2)
      expect(csv[0]["email"]).to eq("jane@example.com")
      expect(csv[1]["first_name"]).to eq("John")
      expect(csv[1]["application_status"]).to eq("pending_conditions")
    end
  end
end
