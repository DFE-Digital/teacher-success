class ApplicationController < ActionController::Base
  default_form_builder(GOVUKDesignSystemFormBuilder::FormBuilder)

  before_action :add_home_breadcrumb
  before_action :basic_auth, unless: -> { Rails.env.development? || Rails.env.test? } 

  def add_home_breadcrumb
    return if request.path == root_path

    breadcrumb "Home", :root_path
  end

  private

  def basic_auth
    http_basic_authenticate_with(
      name: ENV["BASIC_AUTH_USERNAME"],
      password: ENV["BASIC_AUTH_PASSWORD"],
    )
  end
end
