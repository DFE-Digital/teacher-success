# frozen_string_literal: true

class Cards::SimpleCardComponent < ApplicationComponent
  def initialize(title:, description:, path:, heading_tag: "h2", target: "_self", data: {})
    @title = title
    @description = description
    @path = path
    @heading_tag = heading_tag
    @target = target
    @data = data
  end
end
