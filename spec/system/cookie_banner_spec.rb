require "rails_helper"

RSpec.describe "Cookie Consent Banner", type: :system do
  let(:cookie_name) { "teach_preferences" }

  before do
    driven_by(:selenium_chrome_headless)
  end

  def set_cookie(name:, value:)
    page.driver.browser.manage.add_cookie(
      name: name,
      value: CGI.escape(value.to_json)
    )
  end

  def get_cookie(name:)
    cookie = page.driver.browser.manage.all_cookies.find { |c| c[:name] == name }

    JSON.parse(CGI.unescape(cookie[:value]))
  rescue
    nil
  end

  describe "visiting the homepage" do
    context "when no cookie is set" do
      it "shows the cookie banner" do
        visit root_path
        expect(page).to have_selector(".govuk-cookie-banner")
      end
    end

    context "when cookie is set with nonEssential: true" do
      before do
        visit root_path
        set_cookie(name: cookie_name, value: { non_essential: true })
      end

      it "does not show the cookie banner" do
        visit root_path
        expect(page).not_to have_selector(".govuk-cookie-banner")
      end
    end
  end

  describe "accepting cookies" do
    before { visit root_path }

    it "sets the non_essential preference to true" do
      expect(page).to have_selector(".govuk-cookie-banner")
      click_button "Accept additional cookies"
      expect(page).not_to have_selector(".govuk-cookie-banner", wait: 2)
      non_essential_preference = get_cookie(name: cookie_name).dig("non_essential")
      expect(non_essential_preference).to be true
    end

    it "hides the cookie banner" do
      click_button "Accept additional cookies"
      expect(page).not_to have_selector(".govuk-cookie-banner", wait: 2)
    end

    it "shows a flash notification" do
      click_button "Accept additional cookies"
      expect(page).to have_content("Your cookie preferences have been saved", wait: 2)
    end

    it "hides the banner on subsequent page loads" do
      click_button "Accept additional cookies"
      visit "/cookies"
      expect(page).not_to have_selector(".govuk-cookie-banner", wait: 5)
    end
  end

  describe "rejecting cookies" do
    before { visit root_path }

    it "sets the non essential preference to false" do
      expect(page).to have_selector(".govuk-cookie-banner")
      click_button "Reject additional cookies"
      expect(page).not_to have_selector(".govuk-cookie-banner", wait: 2)
      non_essential_preference = get_cookie(name: cookie_name).dig("non_essential")
      expect(non_essential_preference).to be false
    end

    it "hides the cookie banner" do
      click_button "Reject additional cookies"
      expect(page).not_to have_selector(".govuk-cookie-banner", wait: 2)
    end

    it "shows a flash notification" do
      click_button "Accept additional cookies"
      expect(page).to have_content("Your cookie preferences have been saved", wait: 2)
    end

    it "hides the banner on subsequent page loads" do
      click_button "Reject additional cookies"
      visit "/cookies"
      expect(page).not_to have_selector(".govuk-cookie-banner", wait: 5)
    end
  end
end
