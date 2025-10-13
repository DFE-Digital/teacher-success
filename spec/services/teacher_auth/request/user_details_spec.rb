require "rails_helper"

RSpec.describe TeacherAuth::Request::UserDetails do
  subject(:user_details) { described_class.new(token) }

  let(:token) { "token" }

  describe "#call" do
    context "when the response is successful" do
      before do
        stub_successful_request
      end

      it "returns the details of a user" do
        expect(user_details.call).to eq(
          {
            "trn" => "1234567",
            "firstName" => "Joe",
            "middleName" => "",
            "lastName" => "Bloggs",
            "dateOfBirth" => "1990-01-01",
            "nationalInsuranceNumber" => "NI123",
            "emailAddress" => "joe_bloggs@example.com",
            "qts" => nil,
            "eyts" => nil,
            "routesToProfessionalStatuses" => [
              {
                "routeToProfessionalStatusType" => { "routeToProfessionalStatusTypeId" => "97497716-5ac5-49aa-a444-27fa3e2c152a", "name" => "Provider led Postgrad", "professionalStatusType" => "QualifiedTeacherStatus" },
                "status" => "InTraining", "trainingStartDate" => "2001-01-01",
                "trainingEndDate" => "2001-04-04",
                "trainingSubjects" => [ { "reference" => "123456", "name" => "Maths With Computer Science" } ],
                "trainingAgeSpecialism" => { "type" => "KeyStage1" },
                "trainingProvider" => { "ukprn" => "123456789", "name" => "Birmingham City University" },
                "degreeType" => { "degreeTypeId" => "123abc", "name" => "BSc" }
              }
            ],
            "qtlsStatus" => "None"
           }
        )
      end
    end

    context "when the response is unsuccessful" do
      before do
        stub_failed_request
      end

      it "returns an empty hash" do
        expect(user_details.call).to eq({})
      end
    end
  end

  private

  def stub_successful_request
    training_details = {
      "routeToProfessionalStatusType" => { "routeToProfessionalStatusTypeId" => "97497716-5ac5-49aa-a444-27fa3e2c152a", "name" => "Provider led Postgrad", "professionalStatusType" => "QualifiedTeacherStatus" },
      "status" => "InTraining", "trainingStartDate" => "2001-01-01",
      "trainingEndDate" => "2001-04-04",
      "trainingSubjects" => [ { "reference" => "123456", "name" => "Maths With Computer Science" } ],
      "trainingAgeSpecialism" => { "type" => "KeyStage1" },
      "trainingProvider" => { "ukprn" => "123456789", "name" => "Birmingham City University" },
      "degreeType" => { "degreeTypeId" => "123abc", "name" => "BSc" }
    }
    request_body = { "trn" => "1234567",
                    "firstName" => "Joe",
                    "middleName" => "",
                    "lastName" => "Bloggs",
                    "dateOfBirth" => "1990-01-01",
                    "nationalInsuranceNumber" => "NI123",
                    "emailAddress" => "joe_bloggs@example.com",
                    "qts" => nil,
                    "eyts" => nil,
                    "routesToProfessionalStatuses" => [ training_details ],
                    "qtlsStatus" => "None" }
    stub_request(:get, "https://teacher_auth.gov.uk/person").
      to_return(status: 200, body: request_body.to_json, headers: {})
  end

  def stub_failed_request
    stub_request(:get, "https://teacher_auth.gov.uk/person").
      to_return(status: 404, body: {}.to_json, headers: {})
  end
end
