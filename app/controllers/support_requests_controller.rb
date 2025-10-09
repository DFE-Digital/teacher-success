class SupportRequestsController < ApplicationController
  before_action :set_frontmatter
  def new
    @support_request = SupportRequest.new

    breadcrumb "Get support", new_support_request_path
  end

  def create
    @support_request = SupportRequest.new(support_request_params)
    if @support_request.save
      flash = {
        title: "Success",
        heading: "Support request submitted",
        description: "Your request for support has been submitted to our technical team. We will work to resolve your issue as soon as we can."
      }

      redirect_to new_support_request_path, flash: { success: flash }
    else
      render :new
    end
  end

  private

  def set_frontmatter
    @front_matter = { page_header: { title: "Get support" } }
  end

  def support_request_params
    params.require(:support_request).permit(
      :name, :email, :support_request, :area_of_website, :area_of_website_url, :problem,
    )
  end
end
