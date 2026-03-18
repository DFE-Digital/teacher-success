require "rails_helper"

RSpec.describe "Robots", type: :request do
  describe "GET /robots.txt" do
    context "when the environment is not production" do
      it "returns a disallow for all urls" do
        get "/robots.txt"

        expect(response.body).to eq(<<~ROBOTS
            User-agent: *
            Disallow: /
          ROBOTS
        )
      end
    end

    context "when the environment is production" do
      before do
        allow(Rails).to receive(:env).and_return("production".inquiry)
      end

      it "returns a disallow for all urls, except the homepage" do
        get "/robots.txt"

        expect(response.body).to eq(<<~ROBOTS
            User-agent: *
            Allow: /$
            Disallow: /
          ROBOTS
        )
      end
    end
  end
end
