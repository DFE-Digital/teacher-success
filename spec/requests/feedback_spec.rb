require "rails_helper"

RSpec.describe "Feedbacks", type: :request do
  let(:feedback) { build(:feedback) }

  describe "GET /feedback" do
    let(:username) { ENV["BASIC_AUTH_USERNAME"] }
    let(:password) { ENV["BASIC_AUTH_PASSWORD"] }
    let!(:feedback) { create(:feedback, :with_contact_details) }

    context "with valid basic auth" do
      it "renders the index" do
        get feedback_path, headers: {
          "HTTP_AUTHORIZATION" => ActionController::HttpAuthentication::Basic.encode_credentials(username, password)
        }

        expect(response).to have_http_status(:ok)
        expect(response.body).to include(feedback.email)
      end
    end

    context "without basic auth" do
      it "prompts for authentication" do
        get feedback_path

        expect(response).to have_http_status(:unauthorized)
        expect(response.headers["WWW-Authenticate"]).to include("Basic realm")
      end
    end
  end

  describe "GET /feedback/new" do
    it "renders the new feedback form" do
      get new_feedback_path

      expect(response).to have_http_status(:ok)
      expect(response.body).to include("Give feedback")
    end

    context "when given a url in the params" do
      it "renders the new feedback form with a prefilled topic and url" do
        get new_feedback_path(url: "example.com")

        expect(response).to have_http_status(:ok)
        expect(response.body).to include("Give feedback")
        expect(response.body).to include(
          "<input id=\"feedback-topic-page-field\" aria-describedby=\"feedback-topic-page-hint\" class=\"govuk-radios__input\" type=\"radio\" value=\"page\" checked=\"checked\" name=\"feedback[topic]\" />"
        )
        expect(response.body).to include(
          "<input id=\"feedback-url-field\" class=\"govuk-input\" type=\"text\" value=\"example.com\" name=\"feedback[url]\" />"
        )
      end
    end
  end

  describe "POST /feedback" do
    context "with valid parameters" do
      let(:feedback_attributes) { build(:feedback).attributes }

      it "creates feedback and redirects with success flash" do
        expect {
          post feedback_path, params: { feedback: feedback_attributes }
        }.to change(Feedback, :count).by(1)

        expect(response).to redirect_to(new_feedback_path)
        follow_redirect!

        expect(response.body).to include("Feedback submitted")
      end
    end

    context "with invalid parameters" do
      let(:feedback_attributes) { build(:feedback, rating: nil).attributes }

      it "re-renders the form with errors" do
        expect {
          post feedback_path, params: { feedback: feedback_attributes }
        }.not_to change(Feedback, :count)

        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.body).to include("Give feedback")
      end
    end
  end
end
