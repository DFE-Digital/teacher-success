class ContentController < ApplicationController
  before_action :set_page

  def show
    @content = view_context.render(inline: @content)
    @content = GovukMarkdown.render(@content)

    render template: "content/show"
  end

  private

  def set_page
    @front_matter, @content = ContentLoader.instance.find_by_slug(params[:slug])
  rescue PageNotFoundError
    redirect_to(controller: "errors", action: "not_found")
  end
end
