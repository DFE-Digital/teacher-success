class SitemapController < ApplicationController
  def index
    @pages = ContentLoader.instance.pages
      .sort_by { |slug, page| page.dig(:front_matter, :title) }
  end
end
