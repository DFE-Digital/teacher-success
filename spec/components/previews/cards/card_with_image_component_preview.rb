class Cards::CardWithImageComponentPreview < ApplicationComponentPreview
  def default
    render Cards::CardWithImageComponent.new(
      title: "Hello world",
      description: random_text(100),
      button_text: "Continue",
      button_href: root_path,
      image: "content/teacher2.png",
      image_alt: "A teacher in a classroom"
    )
  end
end