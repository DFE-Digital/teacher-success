require "rails_helper"

RSpec.describe "SupportRequests", type: :request do
  describe "GET /support_requests" do
    let(:username) { ENV["BASIC_AUTH_USERNAME"] }
    let(:password) { ENV["BASIC_AUTH_PASSWORD"] }
    let!(:support_request) { create(:support_request) }

    context "with valid basic auth" do
      it "renders the index" do
        get support_requests_path, headers: {
          "HTTP_AUTHORIZATION" => ActionController::HttpAuthentication::Basic.encode_credentials(username, password)
        }

        expect(response).to have_http_status(:ok)
        expect(response.body).to include(support_request.email)
      end
    end

    context "without basic auth" do
      it "prompts for authentication" do
        get support_requests_path

        expect(response).to have_http_status(:unauthorized)
        expect(response.headers["WWW-Authenticate"]).to include("Basic realm")
      end
    end
  end

  describe "GET /support_request/new" do
    it "renders the new support request form" do
      get new_support_request_path

      expect(response).to have_http_status(:ok)
      expect(response.body).to include("Get support")
    end
  end

  describe "POST /support_requests" do
    context "with valid parameters" do
      let(:support_request_attributes) { build(:support_request).attributes }

      it "creates a support request and redirects with success flash" do
        expect {
          post support_requests_path, params: { support_request: support_request_attributes }
        }.to change(SupportRequest, :count).by(1)

        expect(response).to redirect_to(new_support_request_path)
        follow_redirect!

        expect(response.body).to include("Support request submitted")
      end
    end

    context "with invalid parameters" do
      it "re-renders the form with errors" do
        expect {
          post support_requests_path, params: { support_request: { name: nil } }
        }.not_to change(SupportRequest, :count)

        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.body).to include("Get support")
      end
    end
  end
end
