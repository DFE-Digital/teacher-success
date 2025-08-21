class EventsController < ApplicationController
  protect_from_forgery with: :null_session

  def create
    event = DfE::Analytics::Event.new
      .with_type(event_params[:type])
      .with_data(event_params[:data].to_h)
      .with_request_details(request)
      .with_response_details(response)

    DfE::Analytics::SendEvents.do([ event ])

    head :ok
  end

  private

  def event_params
    params.require(:event).permit(:type, data: {})
  end
end
