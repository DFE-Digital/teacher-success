module FeedbackHelper
  def formatted_enum(field)
    Feedback.send(field).map { |key, _value| [ key.humanize, key ] }
  end

  def humanized_boolean(boolean, truthy = "Yes", falsey = "No")
    boolean ? truthy : falsey
  end

  def rating_tag(feedback)
    colour = case feedback.rating_before_type_cast
    when 1 then "Red"
    when 2 then "Orange"
    when 3 then "Yellow"
    when 4 then "Turquoise"
    when 5 then "Green"
    end

    govuk_tag(text: feedback.rating.humanize, colour: colour.downcase)
  end

  def feedback_emoji(feedback)
    case feedback.rating_before_type_cast
    when 1 then ":skull:"
    when 2 then ":slightly-frowning-face:"
    when 3 then ":neutral-face:"
    when 4 then ":smile:"
    when 5 then ":star-struck:"
    end
  end
end
