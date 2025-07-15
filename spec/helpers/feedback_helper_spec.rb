require "rails_helper"

RSpec.describe FeedbackHelper, type: :helper do
  describe "#formatted_enum" do
    context ":ratings" do
      it "returns humanized enum keys with original keys" do
        results = formatted_enum(:ratings)

        expect(results).to eq([
          ["Very satisfied", "very_satisfied"],
          ["Satisfied", "satisfied"], 
          ["Neither satisfied or dissatisfied", "neither_satisfied_or_dissatisfied"], 
          ["Dissatisfied", "dissatisfied"], 
          ["Very dissatisfied", "very_dissatisfied"]
        ])
      end
    end

    context ":topics" do
      it "returns humanized enum keys with original keys" do
        results = formatted_enum(:topics)

        expect(results).to eq([
          ["Site", "site"],
          ["Page", "page"]
        ])
      end
    end
  end

  describe "#humanized_boolean" do
    it "returns 'Yes' when true" do
      expect(humanized_boolean(true)).to eq("Yes")
    end

    it "returns 'No' when false" do
      expect(humanized_boolean(false)).to eq("No")
    end

    it "returns custom truthy/falsey strings" do
      expect(humanized_boolean(false, "Yep", "Nope")).to eq("Nope")
    end
  end
  
  describe "#rating_tag" do
    let(:feedback) do
      double("Feedback",
        rating_before_type_cast: raw_rating,
        rating: rating_text
      )
    end

    before do
      allow(helper).to receive(:govuk_tag).and_return("govuk-tag")
    end

    subject { helper.rating_tag(feedback) }

    context "with rating 1" do
      let(:raw_rating) { 1 }
      let(:rating_text) { "very_bad" }

      it "renders tag with red colour" do
        expect(helper).to receive(:govuk_tag).with(text: "Very bad", colour: "red")
        subject
      end
    end

    context "with rating 5" do
      let(:raw_rating) { 5 }
      let(:rating_text) { "excellent" }

      it "renders tag with green colour" do
        expect(helper).to receive(:govuk_tag).with(text: "Excellent", colour: "green")
        subject
      end
    end
  end

  describe "#feedback_emoji" do
    subject { helper.feedback_emoji(feedback) }

    let(:feedback) { double("Feedback", rating_before_type_cast: rating_value) }

    {
      1 => ":skull:",
      2 => ":slightly-frowning-face:",
      3 => ":neutral-face:",
      4 => ":smile:",
      5 => ":star-struck:"
    }.each do |rating, emoji|
      context "when rating is #{rating}" do
        let(:rating_value) { rating }

        it "returns #{emoji}" do
          expect(subject).to eq(emoji)
        end
      end
    end
  end
end

