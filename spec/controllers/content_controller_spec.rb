require 'rails_helper'

RSpec.describe ContentController, type: :controller do
  describe "#set_layout" do
    let(:front_matter) { {} }

    context "when layout is specified in the front matter" do
      let(:front_matter) { { layout: "article" } }

      it "uses the layout specified in front matter" do
        controller.instance_variable_set(:@front_matter, front_matter)

        expect(controller.send(:set_layout)).to eq("article")
      end
    end

    context "when layout is not specified" do
      it "defaults to application layout" do
        controller.instance_variable_set(:@front_matter, front_matter)

        expect(controller.send(:set_layout)).to eq("application")
      end
    end
  end
end
