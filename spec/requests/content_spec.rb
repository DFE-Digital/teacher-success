# spec/requests/content_spec.rb
require 'rails_helper'

RSpec.describe "Content Pages", type: :request do
  describe "GET /:slug" do
    let(:slug) { "test" }
    let(:front_matter) { {} }
    let(:markdown_content) { '# Hello <%= "World" %>' }

    before do
      allow(CONTENT_LOADER).to receive(:find_by_slug)
        .with(slug)
        .and_return([ front_matter, markdown_content ])
    end

    it "renders the page content" do
      get "/#{slug}"

      expect(response).to have_http_status(:ok)
      expect(response.body).to include("Hello World")
    end

    context "when the page has breadcrumbs" do
      let(:front_matter) do
        {
          breadcrumbs: {
            enable: true,
            crumbs: [
              {
                name: "Breadcrumb 1", path: "/home"
              },
              {
                name: "Breadcrumb 2",
                path: "/help"
              }
            ]
          }
        }
      end
      let(:markdown_content) do
        <<~MARKDOWN
          ---
            breadcrumbs:#{' '}
                enable: true
                crumbs:#{' '}
                    - name: "Breadcrumb 1"
                      path: "/home"
                    - name: "Breadcrumb 2"
                      path: "/help"
          ---
          # Hello <%= "World" %>
        MARKDOWN
      end

      before do
        allow(CONTENT_LOADER).to receive(:find_by_slug)
                                   .with(slug)
                                   .and_return([ front_matter, markdown_content ])
      end

      it "renders te page content with breadcrumbs" do
        get "/#{slug}"

        expect(response).to have_http_status(:ok)
        expect(response.body).to include("Hello World")
        expect(response.body).to include("Breadcrumb 1")
        expect(response.body).to include("Breadcrumb 2")
      end
    end

    context "when the page is not found" do
      let(:slug) { "missing-page" }

      before do
        allow(CONTENT_LOADER).to receive(:find_by_slug)
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
