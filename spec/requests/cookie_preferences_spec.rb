require "rails_helper"

RSpec.describe "CookiePreferences", type: :request do
  describe "PATCH /cookie_preferences" do
    let(:cookie_name) { "teach_preferences" }
    let(:update_path) { edit_cookie_preferences_path }
    let(:non_essential) { false }
    let(:params) { { cookie_preferences: { non_essential: non_essential } } }

    context "when setting non_essential to true" do
      let(:non_essential) { true }

      it "sets the cookie with non_essential: true and redirects with success flash" do
        patch cookie_preferences_path, params: params

        expect(response).to redirect_to(update_path)

        follow_redirect!

        expect(response.body).to include("Cookie Preferences Updated")
        expect(cookies[cookie_name]).to be_present

        cookie = JSON.parse(cookies[cookie_name])
        expect(cookie["non_essential"]).to eq(true)
      end
    end

    context "when setting non_essential to false" do
      let(:non_essential) { false }

      it "sets the cookie with non_essential: false" do
        patch cookie_preferences_path, params: params

        expect(response).to redirect_to(update_path)

        cookie = JSON.parse(cookies[cookie_name])
        expect(cookie["non_essential"]).to eq(false)
      end
    end

    context "when parameter is missing" do
      it "sets non_essential to nil" do
        patch cookie_preferences_path, params: {}

        cookie = JSON.parse(cookies[cookie_name])
        expect(cookie["non_essential"]).to eq(nil)
      end
    end
  end
end
