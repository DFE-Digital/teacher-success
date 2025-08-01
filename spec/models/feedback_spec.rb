require 'rails_helper'

RSpec.describe Feedback, type: :model do
  describe ".ratings" do
    it "defines ratings" do
      expect(described_class.ratings).to eq({
        "very_satisfied" => 5,
        "satisfied" => 4,
        "neither_satisfied_or_dissatisfied" => 3,
        "dissatisfied" => 2,
        "very_dissatisfied" => 1
      })
    end
  end

  describe ".topics" do
    it "defines correct enum values" do
      expect(described_class.topics).to eq({
        "site" => 0,
        "page" => 1
      })
    end
  end

  describe "validations" do
    let(:feedback) { build(:feedback) }

    it "is valid" do
      expect(feedback).to be_valid
    end

    context "when rating is missing" do
      let(:feedback) { build(:feedback, rating: nil) }

      it "is not valid" do
        expect(feedback).to be_invalid
        expect(feedback.errors[:rating]).to include("Select a rating from the list")
      end
    end

    context "when rating is not in the defined enum" do
      let(:feedback) { build(:feedback, rating: "invalid") }

      it "raises an ArgumentError" do
        expect { feedback }.to raise_error(ArgumentError)
      end
    end

    context "when topic is missing" do
      let(:feedback) { build(:feedback, topic: nil) }

      it "is not valid" do
        expect(feedback).to be_invalid
        expect(feedback.errors[:topic]).to include("Select the area of the website relating to your feedback")
      end
    end

    context "when topic is not in the defined enum" do
      let(:feedback) { build(:feedback, topic: "invalid") }

      it "raises an ArgumentError" do
        expect { feedback }.to raise_error(ArgumentError)
      end
    end

    context "when topic is 'page'" do
      let(:topic)  { "page" }
      let(:url) { "https://example.com/page" }
      let(:feedback) { build(:feedback, topic: topic, url: url) }

      context "and url is present" do
        it "is valid" do
          expect(feedback).to be_valid
        end
      end

      context "and url is blank" do
        let(:url) { nil }

        it "is not valid" do
          expect(feedback).to be_invalid
          expect(feedback.errors[:url]).to include("Please enter a valid URL")
        end
      end

      context "and url is invalid" do
        let(:url) { "invalid" }

        it "is not valid" do
          expect(feedback).to be_invalid
          expect(feedback.errors[:url]).to include("Please enter a valid URL")
        end
      end
    end

    context "when topic is 'site'" do
      let(:feedback) { build(:feedback, topic: "site") }

      it "is valid" do
        expect(feedback).to be_valid
      end
    end

    context "when can_contact is missing" do
      let(:feedback) { build(:feedback, can_contact: nil) }

      it "is not valid" do
        expect(feedback).to be_invalid
        expect(feedback.errors[:can_contact]).to include("Please select a contact preference")
      end
    end

    context "when can_contact is true" do
      let(:feedback) { build(:feedback, can_contact: true, email: email) }

      context "and email is blank" do
        let(:email) { nil }

        it "is not valid" do
          expect(feedback).to be_invalid
          expect(feedback.errors[:email]).to include("Please enter a valid email")
        end
      end

      context "and email is valid" do
        let(:email) { "test@test.com" }

        it "is valid" do
          expect(feedback).to be_valid
        end
      end
    end
  end
end
