# frozen_string_literal: true

class Cards::CardWithImageComponent < ViewComponent::Base
  def initialize(title:, description:, image: nil, button_text:, button_href:, heading_tag: "h2")
    @title = title
    @description = description
    @button_text = button_text
    @button_href = button_href
    @heading_tag = heading_tag
    @image = image
  end
end
