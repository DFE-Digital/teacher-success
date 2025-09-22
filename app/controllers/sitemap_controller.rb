class SitemapController < ApplicationController
  def index
    @pages = CONTENT_LOADER.pages.each do |path, page|
      page[:last_updated_at] = PageModification.find_by(path:).updated_at.strftime("%d %B %Y")
    end.sort_by { |slug, page| page.dig(:front_matter, :title) }
  end
end
