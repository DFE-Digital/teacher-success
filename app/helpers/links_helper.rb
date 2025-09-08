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

  def tracked_link_of_style(method_name, *options, **kwargs)
    permitted_styles = %i[
      govuk_button_link_to
      govuk_link_to
      govuk_mail_to
    ]

    # Append a visually hidden screen reader hint for link_to and button_link_to helpers
    if method_name.in?(%i[govuk_link_to govuk_button_link_to])
      text_with_screen_reader_hint = safe_join([
        options.first,
        content_tag(:span, ". This is an external link", class: "govuk-visually-hidden")
      ])

      options[0] = text_with_screen_reader_hint
    end

    raise ArgumentError, "Supports #{permitted_styles.to_sentence}" unless permitted_styles.include?(method_name)

    send(method_name, *options, **kwargs.deep_merge(data: {
      controller: "tracked-link",
      action: %w[click auxclick contextmenu].map { |a| "#{a}->tracked-link#track" }.join(" "),
      "tracked-link-target": "link",
      "link-type": kwargs.delete(:link_type),
      "link-subject": kwargs.delete(:link_subject),
      "tracked-link-text": kwargs.delete(:tracked_link_text),
      "tracked-link-href": kwargs.delete(:tracked_link_href)
    }))
  end

  def visually_hidden_text(text:, prefix: nil, suffix: nil)
    prefix_content = content_tag(:span, prefix, class: "govuk-visually-hidden") if prefix.present?
    suffix_content = content_tag(:span, suffix, class: "govuk-visually-hidden") if suffix.present?
    safe_join([
      prefix_content,
      text,
      suffix_content,
    ].compact)
  end
end
