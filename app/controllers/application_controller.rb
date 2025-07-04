class ApplicationController < ActionController::Base
  default_form_builder(GOVUKDesignSystemFormBuilder::FormBuilder)

  include Pagy::Backend

  before_action :add_home_breadcrumb

  def add_home_breadcrumb
    return if request.path == root_path

    breadcrumb "Home", :root_path
  end
end
