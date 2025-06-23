# frozen_string_literal: true

require "rails_helper"

RSpec.describe Cards::CardWithImageComponent, type: :component do
  let(:title) { "Title" }
  let(:description) { "Description" }
  let(:image) { "image.png" }
  let(:button_text) { "Click me" }
  let(:button_href) { "/" }

  let(:component) { 
    described_class.new(
      title: title,
      description: description,
      button_text: button_text,
      button_href: button_href,
    )
  }

  subject do
    render_inline(component)
    page
  end

  it { is_expected.to have_css(".card-with-image") }
  it { is_expected.to have_css(".card-with-image .content h2", text: title) }
  it { is_expected.to have_css(".card-with-image .content p", text: description) }
  
  context "when the heading_tag is overridden" do
    let(:custom_heading_tag) { "h4" }

    let(:component) do
      described_class.new(
        title: title,
        description: description,
        button_text: button_text,
        button_href: button_href,
        heading_tag: custom_heading_tag
      )
    end

    it { is_expected.to have_css(".card-with-image .content #{custom_heading_tag}", text: title) }
  end

  context "with an image" do
    let(:image) { "fake-image.png" }

    let(:component) { 
      described_class.new(
        title: title,
        description: description,
        button_text: button_text,
        button_href: button_href,
        image: image
      )
    }

    it { is_expected.to have_css("img[src*='assets/fake-image']") }
  end
end
