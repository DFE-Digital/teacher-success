class ContentController < ApplicationController
  before_action :set_page
  before_action :set_breadcrumbs

  layout :set_layout

  def show
  end

  private

  def set_page
    @front_matter, @content = CONTENT_LOADER.find_by_slug(params[:slug])
  rescue PageNotFoundError
    redirect_to(controller: "errors", action: "not_found")
  end

  def set_layout
    @front_matter[:layout].presence || "application"
  end

  def set_breadcrumbs
    if @front_matter.dig(:breadcrumbs, :crumbs)
      @front_matter.dig(:breadcrumbs, :crumbs).map do |crumb|
        breadcrumb crumb[:name], crumb[:path], match: :exact
      end
    else
      breadcrumb(@front_matter[:title], request.path, match: :exact) if @front_matter[:title]
    end
  end
end
