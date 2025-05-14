class PageNotFoundError < StandardError
  def initialize(slug)
    super("Page not found for slug: '#{slug}'")
  end
end
