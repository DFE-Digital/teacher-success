class ContentLoader
  include Singleton

  CONTENT_DIR = Rails.root.join("app", "views", "content")
  CONFIG_VARIABLES_PATH = Rails.root.join("config/variables.yml")

  attr_reader :pages

  def initialize
    @pages ||= load_content_pages
  end

  def find_by_slug(slug)
    page = @pages[slug]
    raise PageNotFoundError.new(slug) unless page

    [page[:front_matter], page[:content]]
  end

  def navigation_items
    @pages.values.select { |page| page[:front_matter][:navigation].present? }
      .sort_by { it.dig(:front_matter, :navigation, :order) }
      .map do |page|
      {
        text: page.dig(:front_matter, :navigation, :title),
        href: page.dig(:front_matter, :navigation, :path)
      }
    end
  end

  private

  def load_content_pages
    pages = {}

    Dir.glob("#{CONTENT_DIR}/**/*.md").each do |file_path|
      front_matter, content = parse_markdown_file(file_path)

      slug = Pathname.new(file_path)
        .relative_path_from(CONTENT_DIR)
        .to_s
        .sub(/\.md$/, "")

      content = substitute_variables(front_matter, content)

      pages[slug] = {
        front_matter: front_matter,
        content: content
      }
    end

    pages
  end

  def parse_markdown_file(file_path)
    parsed = FrontMatterParser::Parser.parse_file(file_path)

    front_matter = parsed.front_matter.with_indifferent_access
    content = parsed.content

    [ front_matter, content ]
  end

  def substitute_variables(front_matter, content)
    front_matter_variables  = front_matter[:variables] || {}
    config_variables        = YAML.load_file(CONFIG_VARIABLES_PATH)
    
    variables = config_variables.merge(front_matter_variables)
    
    content.gsub(/\$(\w+)\$/) do |match|
      variable_name = match[1..-2]
      variable_value = variables[variable_name]
      variable_value || match
    end
  end
end
