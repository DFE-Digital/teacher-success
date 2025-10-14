require "rails_helper"

RSpec.describe "Feedbacks", type: :request do
  describe "POST /events" do
    it "dispatches a DfE Analytics event" do
      allow(DfE::Analytics::SendEvents).to receive(:do).and_return(true)

      post events_path, params: { event: { type: :tracked_link_clicked } }

      expect(response).to have_http_status(:ok)
    end
  end
end
