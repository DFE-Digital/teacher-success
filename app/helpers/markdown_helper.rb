module MarkdownHelper
  def markdown_with_erb(markdown)
    evaluated = render(
      inline: markdown,
      type: :erb,
      variants: lookup_context.variants,
      formats:  lookup_context.formats
    ).gsub(/>\s*\n\s*</, "><") # Remove newlines and spaces between adjacent HTML tags as these can get rendered to <p> tags in the markdown parser

    GovukMarkdown.render(evaluated).html_safe
  end
end
