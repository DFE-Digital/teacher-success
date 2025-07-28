# frozen_string_literal: true

class Cards::QuoteComponent < ViewComponent::Base
  def initialize(text:, attribution:)
    @text = text
    @attribution = attribution
  end
end
