# frozen_string_literal: true

class Cards::SimpleCardComponent < ViewComponent::Base
  def initialize(title:, description:, path:)
    @title = title
    @description = description
    @path = path
  end
end
