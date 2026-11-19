class Cards::QuoteComponentPreview < ApplicationComponentPreview
  def default
    render Cards::QuoteComponent.new(text: "Hello world #{random_text(100)}", attribution: "Trainee from 2024/25")
  end
end
