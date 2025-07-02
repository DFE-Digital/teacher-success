module FeedbackHelper
  def formatted_enum(field)
    Feedback.send(field).map { |key, _value| [key.humanize, key] }
  end
end
