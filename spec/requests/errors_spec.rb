require "rails_helper"

RSpec.describe "Errors", type: :request do
  describe "GET /404" do
    it "renders the not_found template with 404 status" do
      get "/404"

      expect(response).to have_http_status(:not_found)
      expect(response.body).to include("Page not found")
    end
  end

  describe "GET /422" do
    it "renders the unprocessable_entity template with 422 status" do
      get "/422"

      expect(response).to have_http_status(:unprocessable_entity)
      expect(response.body).to include("Sorry, there’s a problem with the service")
    end
  end

  describe "GET /429" do
    it "renders the too_many_requests template with 429 status" do
      get "/429"

      expect(response).to have_http_status(:too_many_requests)
      expect(response.body).to include("Sorry, there’s a problem with the service")
    end
  end

  describe "GET /500" do
    it "renders the internal_server_error template with 500 status" do
      get "/500"

      expect(response).to have_http_status(:internal_server_error)
      expect(response.body).to include("Sorry, there’s a problem with the service")
    end
  end
end

