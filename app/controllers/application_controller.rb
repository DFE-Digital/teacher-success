class ApplicationController < ActionController::Base
  default_form_builder(GOVUKDesignSystemFormBuilder::FormBuilder)

  include Pagy::Backend
  include DfE::Analytics::Requests

  before_action :add_home_breadcrumb
  helper_method :current_user, :user_signed_in?

  def add_home_breadcrumb
    return if request.path == root_path

    breadcrumb "Home", :root_path
  end

  def current_user
    @current_user ||= OneLoginSignInUser.load_from_session(session)&.user
  end

  def user_signed_in?
    current_user.present?
  end

  def sign_in_user
    @sign_in_user ||= OneLoginSignInUser.load_from_session(session)
  end
end
