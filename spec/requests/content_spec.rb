# spec/requests/content_spec.rb
require 'rails_helper'

RSpec.describe "Content Pages", type: :request do
  describe "GET /:slug" do
    let(:slug) { "test" }
    let(:front_matter) { {} }
    let(:markdown_content) { '# Hello <%= "World" %>' }

    before do
      allow(ContentLoader.instance).to receive(:find_by_slug)
        .with(slug)
        .and_return([ front_matter, markdown_content ])
    end

    it "renders the page content" do
      get "/#{slug}"

      expect(response).to have_http_status(:ok)
      expect(response.body).to include("Hello World")
    end

    context "when the page is not found" do
      let(:slug) { "missing-page" }

      before do
        allow(ContentLoader.instance).to receive(:find_by_slug)
          .with(slug)
          .and_raise(PageNotFoundError.new(slug))
      end

      it "redirects to the errors#not_found page" do
        get "/#{slug}"

        expect(response).to redirect_to(controller: "errors", action: "not_found")
      end
    end
  end
end
