require "rails_helper"

RSpec.describe "PageFeedbacks", type: :request do
  let(:page_feedback) { build(:page_feedback) }

  describe "GET /page_feedback" do
    let(:username) { ENV["BASIC_AUTH_USERNAME"] }
    let(:password) { ENV["BASIC_AUTH_PASSWORD"] }
    let!(:page_feedback) { create(:page_feedback) }

    context "with valid basic auth" do
      it "renders the index" do
        get page_feedback_path, headers: {
          "HTTP_AUTHORIZATION" => ActionController::HttpAuthentication::Basic.encode_credentials(username, password)
        }

        expect(response).to have_http_status(:ok)
        expect(response.body).to include(page_feedback.feedback)
      end
    end

    context "without basic auth" do
      it "prompts for authentication" do
        get page_feedback_path

        expect(response).to have_http_status(:unauthorized)
        expect(response.headers["WWW-Authenticate"]).to include("Basic realm")
      end
    end
  end

  describe "POST /page_feedback" do
    context "with valid parameters" do
      let(:feedback_attributes) { build(:page_feedback).attributes }

      it "creates page_feedback and redirects with success flash" do
        expect {
          post page_feedback_path, params: { page_feedback: feedback_attributes }
        }.to change(PageFeedback, :count).by(1)

        expect(response).to redirect_to(root_path)
        follow_redirect!

        expect(response.body).to include("Feedback submitted")
      end
    end
  end
end
