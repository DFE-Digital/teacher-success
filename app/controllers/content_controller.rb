class ContentController < ApplicationController
  before_action :set_page
  
  layout :set_layout

  def show
    @content = view_context.render(inline: @content)
    @content = GovukMarkdown.render(@content)

    render "content/show"
  end

  private

  def set_page
    @front_matter, @content = ContentLoader.instance.find_by_slug(params[:slug])
  rescue PageNotFoundError
    redirect_to(controller: "errors", action: "not_found")
  end

  def set_layout
    @front_matter[:layout].presence || "application"
  end
end
