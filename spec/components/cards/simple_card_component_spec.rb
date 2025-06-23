# frozen_string_literal: true

require "rails_helper"

RSpec.describe Cards::SimpleCardComponent, type: :component do
  let(:title) { "Title" }
  let(:description) { "Description" }
  let(:path) { "/" }

  let(:component) { 
    described_class.new(
      title: title,
      description: description,
      path: path
    )
  }

  subject do
    render_inline(component)
    page
  end

  it { is_expected.to have_css("a.simple-card") }
  it { is_expected.to have_css("a.simple-card h2.simple-card__title", text: title) }
  it { is_expected.to have_css("a.simple-card p", text: description) }
  
  context "when the heading_tag is overridden" do
    let(:custom_heading_tag) { "h4" }

    let(:component) do
      described_class.new(
        title: title,
        description: description,
        path: path,
        heading_tag: custom_heading_tag
      )
    end

    it { is_expected.to have_css(".simple-card #{custom_heading_tag}", text: title) }
  end
end
