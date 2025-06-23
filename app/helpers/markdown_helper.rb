module MarkdownHelper
  def markdown_with_erb(markdown)
    evaluated = render(
      inline: markdown,
      type: :erb,
      variants: lookup_context.variants,
      formats:  lookup_context.formats
    )

    GovukMarkdown.render(evaluated).html_safe
  end
end
