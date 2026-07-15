class Cards::SimpleCardComponentPreview < ApplicationComponentPreview
  def default
    render_with_template(template:, locals: { title: "Hello world", description: random_text(50) })
  end

  private

  def template
    "templates/simple_card_component_preview_layout"
  end
end
