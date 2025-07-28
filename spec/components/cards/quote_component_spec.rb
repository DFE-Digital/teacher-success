# frozen_string_literal: true

require "rails_helper"

RSpec.describe Cards::QuoteComponent, type: :component do
  let(:text) { "Some text quotation here" }
  let(:attribution) { "Bob" }

  let(:component) {
    described_class.new(
      text: text,
      attribution: attribution
    )
  }

  subject do
    render_inline(component)
    page
  end

  it { is_expected.to have_css("div.quote blockquote", text: text) }
  it { is_expected.to have_css("div.quote p.quote__attribution", text: attribution) }
end

