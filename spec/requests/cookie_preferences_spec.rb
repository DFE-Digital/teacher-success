require "rails_helper"

RSpec.describe "CookiePreferences", type: :request do
  describe "PATCH /cookie_preferences" do
    let(:cookie_name) { "teach_preferences" }
    let(:update_path) { edit_cookie_preferences_path }
    let(:non_essential) { false }
    let(:params) { { cookie_preferences: { non_essential: non_essential } } }

    context "when coming from the cookie_preferences/edit page" do
      let(:headers) { { "HTTP_REFERER" => edit_cookie_preferences_path } }

      context "when setting non_essential to true" do
        let(:non_essential) { true }

        it "sets the cookie with non_essential: true and redirects with success flash" do
          patch cookie_preferences_path, params: params, headers: headers
          expect(response).to redirect_to(edit_cookie_preferences_path)
          follow_redirect!
          expect(response.body).to include("Your cookie preferences have been saved")
          expect(cookies[cookie_name]).to be_present
          cookie = JSON.parse(cookies[cookie_name])
          expect(cookie["non_essential"]).to eq(true)
        end
      end

      context "when setting non_essential to false" do
        let(:non_essential) { false }

        it "sets the cookie with non_essential: false" do
          patch cookie_preferences_path, params: params, headers: headers
          expect(response).to redirect_to(edit_cookie_preferences_path)
          follow_redirect!
          expect(response.body).to include("Your cookie preferences have been saved")
          cookie = JSON.parse(cookies[cookie_name])
          expect(cookie["non_essential"]).to eq(false)
        end
      end

      context "when parameter is missing" do
        it "sets non_essential to nil" do
          patch cookie_preferences_path, params: {}, headers: headers
          expect(response).to redirect_to(edit_cookie_preferences_path)
          follow_redirect!
          expect(response.body).not_to include("Your cookie preferences have been saved")
          cookie = JSON.parse(cookies[cookie_name])
          expect(cookie["non_essential"]).to eq(nil)
        end
      end
    end

    context "when coming from the home page" do
      let(:headers) { { "HTTP_REFERER" => root_path } }

      context "when setting non_essential to true" do
        let(:non_essential) { true }

        it "sets the cookie with non_essential: true and redirects with success flash" do
          patch cookie_preferences_path, params: params, headers: headers
          expect(response).to redirect_to(root_path)
          follow_redirect!
          expect(response.body).to include("Your cookie preferences have been saved")
          expect(cookies[cookie_name]).to be_present
          cookie = JSON.parse(cookies[cookie_name])
          expect(cookie["non_essential"]).to eq(true)
        end
      end

      context "when setting non_essential to false" do
        let(:non_essential) { false }

        it "sets the cookie with non_essential: false" do
          patch cookie_preferences_path, params: params, headers: headers
          expect(response).to redirect_to(root_path)
          follow_redirect!
          expect(response.body).to include("Your cookie preferences have been saved")
          cookie = JSON.parse(cookies[cookie_name])
          expect(cookie["non_essential"]).to eq(false)
        end
      end

      context "when parameter is missing" do
        it "sets non_essential to nil" do
          patch cookie_preferences_path, params: {}, headers: headers
          expect(response).to redirect_to(root_path)
          follow_redirect!
          expect(response.body).not_to include("Your cookie preferences have been saved")
          cookie = JSON.parse(cookies[cookie_name])
          expect(cookie["non_essential"]).to eq(nil)
        end
      end
    end

    context "with no referer" do
      context "when setting non_essential to true" do
        let(:non_essential) { true }

        it "sets the cookie with non_essential: true and redirects with success flash" do
          patch cookie_preferences_path, params: params
          expect(response).to redirect_to(root_path)
          follow_redirect!
          expect(response.body).not_to include("Cookie Preferences Updated")
          expect(cookies[cookie_name]).to be_present
          cookie = JSON.parse(cookies[cookie_name])
          expect(cookie["non_essential"]).to eq(true)
        end
      end

      context "when setting non_essential to false" do
        let(:non_essential) { false }

        it "sets the cookie with non_essential: false" do
          patch cookie_preferences_path, params: params
          expect(response).to redirect_to(root_path)
          follow_redirect!
          expect(response.body).to include("Your cookie preferences have been saved")
          cookie = JSON.parse(cookies[cookie_name])
          expect(cookie["non_essential"]).to eq(false)
        end
      end

      context "when parameter is missing" do
        it "sets non_essential to nil" do
          patch cookie_preferences_path, params: {}
          expect(response).to redirect_to(root_path)
          follow_redirect!
          expect(response.body).not_to include("Your cookie preferences have been saved")
          cookie = JSON.parse(cookies[cookie_name])
          expect(cookie["non_essential"]).to eq(nil)
        end
      end
    end
  end
end
