class SitemapController < ApplicationController
  def index
    @pages = CONTENT_LOADER.pages.sort_by { |slug, page| page.dig(:front_matter, :title) }
  end
end
