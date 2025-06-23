# frozen_string_literal: true

class Cards::SimpleCardComponent < ViewComponent::Base
  def initialize(title:, text:)
    @title = title
    @text = text
  end
end
