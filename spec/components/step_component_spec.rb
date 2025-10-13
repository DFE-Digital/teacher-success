# frozen_string_literal: true

require "rails_helper"

RSpec.describe StepComponent, type: :component do
  let(:title) { "Title" }
  let(:icon) { "tick.svg" }
  let(:icon_alt_text) { "icon alt text" }
  let(:heading_tag) { "h2" }
  let(:classes) { nil }
  let(:content) { "Hello world" }

  let(:component) {
    described_class.new(
      title: title,
      icon: icon,
      icon_alt_text: icon_alt_text,
      heading_tag: heading_tag,
      classes: classes
    )
  }

  subject do
    render_inline(component) { content }
    page
  end

  it { is_expected.to have_css(".step") }
  it { is_expected.to have_css(".step .step__header h2", text: title) }
  it { is_expected.to have_css(".step .step__content") }
  it { is_expected.to have_content("Hello world") }

  context "when the heading_tag is overridden" do
    let(:heading_tag) { "h4" }

    it { is_expected.to have_css(".step .step__header #{heading_tag}", text: title) }
  end

  context "with an image" do
    let(:icon) { "fake-image.png" }
    let(:icon_alt_text) { "fake image alt text" }

    it { is_expected.to have_css("img[src*='assets/fake-image']") }
    it { is_expected.to have_css("img[alt*='#{icon_alt_text}']") }
  end
end
