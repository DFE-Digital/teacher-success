class StepComponentPreview < ApplicationComponentPreview
  def default
    render StepComponent.new(title: "Hello world")
  end
end