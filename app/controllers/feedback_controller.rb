class FeedbackController < ApplicationController
  before_action :set_frontmatter

  http_basic_authenticate_with(
    name: ENV["FEEDBACK_USERNAME"],
    password: ENV["FEEDBACK_PASSWORD"],
    only: :index
  )

  def index
    @pagy, @feedback = pagy(Feedback.order(created_at: :desc))
    @front_matter = { page_header: { title: "Feedback" } }
    breadcrumb "Feedback", feedback_path
  end

  def new
    @feedback = Feedback.new
    breadcrumb "Feedback", new_feedback_path
  end

  def create
    @feedback = Feedback.new(feedback_params)

    if @feedback.save
      flash = {
        title: "Success",
        heading: "Feedback submitted",
        description: "Your feedback will be used to improve this service."
      }

      redirect_to new_feedback_path, flash: { success: flash }
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def set_frontmatter
    @front_matter = { page_header: { title: "Give feedback" } }
  end

  def feedback_params
    params.require(:feedback).permit(:rating, :topic, :description, :email, :can_contact)
  end
end
