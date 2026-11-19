class Cards::PromptComponentPreview < ApplicationComponentPreview
  def default
    render Cards::PromptComponent.new do
      random_text(100)
    end
  end

  def info
    render Cards::PromptComponent.new do
      random_text(100)
    end
  end

  def warning
    render Cards::PromptComponent.new(prompt_type: :warning) do
      random_text(100)
    end
  end

  def error
    render Cards::PromptComponent.new(prompt_type: :error) do
      random_text(100)
    end
  end
end
