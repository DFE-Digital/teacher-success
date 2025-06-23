# frozen_string_literal: true

class Cards::CardWithImageComponent < ViewComponent::Base
  def initialize(title:, description:, button_text:, button_href:)
    @title = title
    @description = description
    @button_text = button_text
    @button_href = button_href
  end
end
