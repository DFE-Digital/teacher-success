module LinksHelper
  def tracked_link_to(*, **)
    tracked_link_of_style(:govuk_link_to, *, **)
  end

  def tracked_button_link_to(*, **)
    tracked_link_of_style(:govuk_button_link_to, *, **)
  end

  def tracked_mail_to(*, **)
    tracked_link_of_style(:govuk_mail_to, *, **)
  end

  def tracked_link_of_style(method_name, *, **kwargs)
    permitted_styles = %i[
      govuk_button_link_to
      govuk_link_to
      govuk_mail_to
    ]

    raise ArgumentError, "Supports #{permitted_styles.to_sentence}" unless permitted_styles.include?(method_name)

    send(method_name, *, **kwargs.deep_merge(data: {
      controller: "tracked-link",
      action: %w[click auxclick contextmenu].map { |a| "#{a}->tracked-link#track" }.join(" "),
      "tracked-link-target": "link",
      "link-type": kwargs.delete(:link_type),
      "link-subject": kwargs.delete(:link_subject),
      "tracked-link-text": kwargs.delete(:tracked_link_text),
      "tracked-link-href": kwargs.delete(:tracked_link_href),
    }))
  end
end
