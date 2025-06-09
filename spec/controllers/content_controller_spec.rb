require 'rails_helper'

RSpec.describe ContentController, type: :controller do
  describe "GET #show" do
    let(:slug) { "test" }
    let(:front_matter) { {} }
    let(:markdown_content) { "# Hello World" }

    before do
      allow(CONTENT_LOADER).to receive(:find_by_slug)
        .with(slug)
        .and_return([ front_matter, markdown_content ])
    end

    context "when layout is specified in the front matter" do
      let(:front_matter) { { layout: "article" } }

      it "uses the layout specified in front matter" do
        get :show, params: { slug: slug }

        expect(controller.send(:set_layout)).to eq("article")
      end
    end

    context "when layout is not specified" do
      it "defaults to application layout" do
        get :show, params: { slug: slug }

        expect(controller.send(:set_layout)).to eq("application")
      end
    end
  end
end
