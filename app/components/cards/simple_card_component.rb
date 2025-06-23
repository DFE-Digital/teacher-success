# frozen_string_literal: true

class Cards::SimpleCardComponent < ViewComponent::Base
  def initialize(title:, description:, path:, heading_tag: "h2")
    @title = title
    @description = description
    @path = path
    @heading_tag = heading_tag
  end
end
