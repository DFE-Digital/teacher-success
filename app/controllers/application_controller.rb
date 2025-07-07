class ApplicationController < ActionController::Base
  default_form_builder(GOVUKDesignSystemFormBuilder::FormBuilder)

    http_basic_authenticate_with(
      name: ENV["BASIC_AUTH_USERNAME"],
      password: ENV["BASIC_AUTH_PASSWORD"],
    ) unless Rails.env.development? || Rails.env.test?

  before_action :add_home_breadcrumb

  def add_home_breadcrumb
    return if request.path == root_path

    breadcrumb "Home", :root_path
  end
end
