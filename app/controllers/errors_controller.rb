class ErrorsController < ApplicationController
  skip_before_action :verify_authenticity_token
  after_action :raise_test_exception

  def not_found
    render "not_found", status: :not_found
  end

  def unprocessable_entity
    render "unprocessable_entity", status: :unprocessable_entity
  end

  def too_many_requests
    render "too_many_requests", status: :too_many_requests
  end

  def internal_server_error
    render "internal_server_error", status: :internal_server_error
  end

  private

  def raise_test_exception
    begin
      1 / 0
    rescue ZeroDivisionError => exception
      Sentry.capture_exception(exception)
    end

    Sentry.capture_message("test message")
  end
end
