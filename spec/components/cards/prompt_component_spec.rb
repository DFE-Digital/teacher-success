require "rails_helper"

RSpec.describe Cards::PromptComponent, type: :component do
  subject(:component) do
    described_class.new(prompt_type:)
  end

  let(:content) { "Hello world" }

  context "when the prompt_type is info" do
    let(:prompt_type) { :info }

    it "returns an info styled prompt" do
      render_inline(component) { content }

      expect(page).to have_element(:div, class: "prompt prompt-home info")
      expect(page).to have_element(:svg, class: "svg-inline--fa fa-circle-info fa-2x")
      expect(page).to have_content("Hello world")
    end
  end

  context "when the prompt_type is warning" do
    let(:prompt_type) { :warning }

    it "returns an info styled prompt" do
      render_inline(component) { content }

      expect(page).to have_element(:div, class: "prompt prompt-home warning")
      expect(page).to have_element(:svg, class: "svg-inline--fa fa-triangle-exclamation fa-2x")
      expect(page).to have_content("Hello world")
    end
  end

  context "when the prompt_type is error" do
    let(:prompt_type) { :error }

    it "returns an info styled prompt" do
      render_inline(component) { content }

      expect(page).to have_element(:div, class: "prompt prompt-home error")
      expect(page).to have_element(:svg, class: "svg-inline--fa fa-triangle-exclamation fa-2x")
      expect(page).to have_content("Hello world")
    end
  end

  describe "#icon_attributes" do
    subject(:icon_attributes) { component.icon_attributes }

    context "when the prompt_type is info" do
      let(:prompt_type) { :info }

      it "returns the info icon attributes" do
        expect(icon_attributes).to eq({
          name: "fa-circle-info",
          data: "circle-info",
          draw: "M256 512A256 256 0 1 0 256 0a256 256 0 1 0 0 512zM216 336l24 0 0-64-24 0c-13.3 0-24-10.7-24-24s10.7-24 24-24l48 0c13.3 0 24 10.7 24 24l0 88 8 0c13.3 0 24 10.7 24 24s-10.7 24-24 24l-80 0c-13.3 0-24-10.7-24-24s10.7-24 24-24zm40-208a32 32 0 1 1 0 64 32 32 0 1 1 0-64z"
        })
      end
    end

    context "when the prompt_type is warning" do
      let(:prompt_type) { :warning }

      it "returns the info icon attributes" do
        expect(icon_attributes).to eq({
          name: "fa-triangle-exclamation",
          data: "triangle-exclamation",
          draw: "M256 0c14.7 0 28.2 8.1 35.2 21l216 400c6.7 12.4 6.4 27.4-.8 39.5S486.1 480 472 480L40 480c-14.1 0-27.2-7.4-34.4-19.5s-7.5-27.1-.8-39.5l216-400c7-12.9 20.5-21 35.2-21zm0 352a32 32 0 1 0 0 64 32 32 0 1 0 0-64zm0-192c-18.2 0-32.7 15.5-31.4 33.7l7.4 104c.9 12.5 11.4 22.3 23.9 22.3 12.6 0 23-9.7 23.9-22.3l7.4-104c1.3-18.2-13.1-33.7-31.4-33.7z"
        })
      end
    end

    context "when the prompt_type is error" do
      let(:prompt_type) { :error }

      it "returns the info icon attributes" do
        expect(icon_attributes).to eq({
          name: "fa-triangle-exclamation",
          data: "triangle-exclamation",
          draw: "M256 0c14.7 0 28.2 8.1 35.2 21l216 400c6.7 12.4 6.4 27.4-.8 39.5S486.1 480 472 480L40 480c-14.1 0-27.2-7.4-34.4-19.5s-7.5-27.1-.8-39.5l216-400c7-12.9 20.5-21 35.2-21zm0 352a32 32 0 1 0 0 64 32 32 0 1 0 0-64zm0-192c-18.2 0-32.7 15.5-31.4 33.7l7.4 104c.9 12.5 11.4 22.3 23.9 22.3 12.6 0 23-9.7 23.9-22.3l7.4-104c1.3-18.2-13.1-33.7-31.4-33.7z"
        })
      end
    end
  end
end
