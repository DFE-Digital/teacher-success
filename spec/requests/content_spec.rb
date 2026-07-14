# spec/requests/content_spec.rb
require 'rails_helper'

RSpec.describe "Content Pages", type: :request do
  describe "GET /:slug" do
    it "redirects single-segment paths to the root page" do
      get "/test"

      expect(response).to redirect_to(root_path)
    end

    it "redirects nested content paths to the root page" do
      get "/prepare-for-training/timeline-of-your-training"

      expect(response).to redirect_to(root_path)
    end

    it "redirects missing paths to the root page" do
      get "/missing-page"

      expect(response).to redirect_to(root_path)
    end

    it "does not affect the root page" do
      get root_path

      expect(response).to have_http_status(:service_unavailable)
    end
  end
end
