module ApplicationHelper
  def navigation_items
    file_path = Rails.root.join("app", "views", "content", "*.md")
  end
end
