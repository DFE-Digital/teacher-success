require "factory_bot"

class ApplicationComponentPreview < ViewComponent::Preview
  include Rails.application.routes.url_helpers

  private

  def random_text(character_length)
    character_length.times.map { (0...(rand(10))).map { ('a'..'z').to_a[rand(26)] }.join }.join(" ")
  end
end
