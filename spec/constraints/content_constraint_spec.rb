require "rails_helper"

RSpec.describe ContentConstraint do
  let(:request) { instance_double(ActionDispatch::Request) }

  before do
    allow(request).to receive(:path).and_return(path)
  end

  describe ".matches?" do
    context "when request does not contain '/rails/active_storage'" do
      let(:path) { "/blah" }

      it "returns false" do
        expect(described_class.matches?(request)).to be(true)
      end
    end

    context "when request contains '/rails/active_storage'" do
      let(:path) { "/rails/active_storage" }

      it "returns false" do
        expect(described_class.matches?(request)).to be(false)
      end
    end
  end
end
