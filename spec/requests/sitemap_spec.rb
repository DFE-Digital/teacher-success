require "rails_helper"

RSpec.describe "Sitemap", type: :request do
  describe "GET /sitemap" do
    let(:pages) do
      {
        "b" => { front_matter: { title: "B Page" }, content: "..." },
        "a" => { front_matter: { title: "A Page" }, content: "..." }
      }
    end

    before do
      stub_const("CONTENT_LOADER", double("ContentLoader", pages: pages, navigation_items: []))
    end

    it "returns http success" do
      get "/sitemap"

      expect(response).to have_http_status(:ok)
    end

    it "assigns sorted pages by title" do
      get "/sitemap"

      html = Nokogiri::HTML(response.body)
      links = html.css("#main-content").css("a").map(&:text)

      expect(links).to eq([ "A Page", "B Page" ])
    end
  end
end
