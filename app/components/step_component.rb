# frozen_string_literal: true

class StepComponent < ApplicationComponent
  def initialize(title:, icon: "tick.svg", icon_alt_text: "Tick icon", heading_tag: "h2", classes: nil)
    @title = title
    @icon = icon
    @icon_alt_text = icon_alt_text
    @heading_tag = heading_tag
    @classes = nil
  end
end
