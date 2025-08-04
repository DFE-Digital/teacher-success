# frozen_string_literal: true

class Cards::QuoteComponent < ViewComponent::Base
  def initialize(text:, attribution:, classes: nil)
    @text = text
    @attribution = attribution
    @classes = classes
  end
end
