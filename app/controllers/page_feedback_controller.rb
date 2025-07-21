class PageFeedbackController < ApplicationController
  before_action :set_frontmatter

  http_basic_authenticate_with(
    name: ENV["BASIC_AUTH_USERNAME"],
    password: ENV["BASIC_AUTH_PASSWORD"],
    only: :index
  )

  def index
    @pagy, @page_feedback = pagy(PageFeedback.order(created_at: :desc))
    breadcrumb "Page feedback", feedback_path
  end

  def create
    @page_feedback = PageFeedback.new(page_feedback_params)
    @page_feedback.url = request.referer

    partial = @page_feedback.save ? "page_feedback/thanks" : "page_feedback/form"

    respond_to do |format|
      format.turbo_stream { render turbo_stream: turbo_stream.replace("page_feedback", partial: partial) }
      format.html { render :new }
    end
  end

  private

  def set_frontmatter
    @front_matter = { page_header: { title: "Page feedback" } }
  end

  def page_feedback_params
    params.require(:page_feedback).permit(:useful, :feedback)
  end
end

