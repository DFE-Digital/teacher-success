# frozen_string_literal: true

class Cards::CardWithImageComponent < ViewComponent::Base
  def initialize(title:, description:, image: nil, image_alt: nil, button_text:, button_href:, heading_tag: "h2", background_color: "light-blue")
    @title = title
    @description = description
    @button_text = button_text
    @button_href = button_href
    @heading_tag = heading_tag
    @image = image
    @image_alt = image_alt
    @background_color = background_color
  end
end
