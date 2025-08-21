require "rails_helper"

RSpec.describe LinksHelper, type: :helper do
  describe "#tracked_link_to" do
    subject(:link) { Capybara.string(helper.tracked_link_to("My link", "/somewhere", link_type: "cta", link_subject: "signup")) }

    it "renders a govuk_link_to with tracking attributes" do
      expect(link).to have_css("a.govuk-link[data-controller='tracked-link']")
      expect(link).to have_css("a[data-action*='click->tracked-link#track']")
      expect(link).to have_css("a[data-action*='auxclick->tracked-link#track']")
      expect(link).to have_css("a[data-action*='contextmenu->tracked-link#track']")
      expect(link).to have_css("a[data-tracked-link-target='link']")
      expect(link).to have_css("a[data-link-type='cta']")
      expect(link).to have_css("a[data-link-subject='signup']")
    end

    it "adds visually hidden external link hint" do
      expect(link).to have_text("My link")
      expect(link).to have_css("span.govuk-visually-hidden", text: ". This is an external link")
    end
  end

  describe "#tracked_button_link_to" do
    subject(:button_link) { Capybara.string(helper.tracked_button_link_to("Proceed", "/action", link_type: "primary")) }

    it "renders a govuk_button_link_to with tracking attributes" do
      expect(button_link).to have_css("a.govuk-button[data-controller='tracked-link']")
      expect(button_link).to have_css("a[data-link-type='primary']")
    end

    it "adds visually hidden external link hint" do
      expect(button_link).to have_text("Proceed")
      expect(button_link).to have_css("span.govuk-visually-hidden", text: ". This is an external link")
    end
  end

  describe "#tracked_mail_to" do
    subject(:mail_link) { Capybara.string(helper.tracked_mail_to("Contact us", "help@example.com", tracked_link_text: "Support")) }

    it "renders a govuk_mail_to with tracking attributes" do
      expect(mail_link).to have_css("a[data-controller='tracked-link']")
      expect(mail_link).to have_css("a[data-tracked-link-text='Support']")
      expect(mail_link.find("a")[:href]).to start_with("mailto:")
    end

    it "renders the provided link text or email" do
      expect(mail_link).to have_text(/Contact us|help@example\.com/)
    end

    it "does not add visually hidden external link hint" do
      expect(mail_link).not_to have_css("span.govuk-visually-hidden", text: ". This is an external link")
    end
  end

  describe "#tracked_link_of_style" do
    it "raises an ArgumentError for unsupported styles" do
      expect {
        helper.tracked_link_of_style(:unsupported, "Bad link", "/bad")
      }.to raise_error(ArgumentError, /Supports/)
    end
  end
end

