require "rails_helper"

RSpec.describe ContentLoader do
  subject(:loader) { described_class.new }

  describe "#find_by_slug" do
    let(:slug) { "test-page" }
    let(:front_matter) { { title: "Test Page" } }
    let(:content) { "Content here" }

    before do
      loader.instance_variable_set(:@pages, {
        slug => { front_matter: front_matter, content: content }
      })
    end

    it "returns front_matter and content for a valid slug" do
      result = loader.find_by_slug(slug)

      expect(result).to eq([front_matter, content])
    end

    it "raises PageNotFoundError for unknown slug" do
      expect {
        loader.find_by_slug("missing")
      }.to raise_error(PageNotFoundError)
    end
  end

  describe "#navigation_items" do
    let(:pages) do
      {
        "page1" => {
          front_matter: { navigation: { order: 2, title: "B", path: "/b" } },
          content: "Content B"
        },
        "page2" => {
          front_matter: { navigation: { order: 1, title: "A", path: "/a" } },
          content: "Content A"
        },
        "page3" => {
          front_matter: { title: "C" },
          content: "Content C"
        }
      }
    end

    before do
      loader.instance_variable_set(:@pages, pages)
    end

    it "returns navigation items sorted by order" do
      expect(loader.navigation_items).to eq([
        { text: "A", href: "/a" },
        { text: "B", href: "/b" }
      ])
    end

    it "excludes pages without navigation data" do
      nav_pages = loader.navigation_items

      expect(nav_pages).not_to include(a_hash_including(text: "C", href: "/c"))
    end
  end

  describe "content loading and variable substitution" do
    # Load a real test page
    let(:slug) { "test" }
    let(:content_dir) { Rails.root.join("spec/fixtures/files/content") }
    let(:markdown_file) { Rails.root.join("spec/fixtures/files/content/test.md") }
    let(:config_variables_path) { Rails.root.join("spec/fixtures/files/config/variables.yml") }

    before do
      stub_const("ContentLoader::CONTENT_DIR", content_dir.to_s)
      stub_const("ContentLoader::CONFIG_VARIABLES_PATH", config_variables_path.to_s)
    end

    it "loads pages with substituted variables from both config/variables.yml and local front matter variables" do
      front_matter, content = loader.find_by_slug(slug)

      expect(content).to eq("This page has bar and Hello variables\n")
    end
  end
end

