require "action_dispatch/testing/integration"
require "digest/sha1"

class PageModificationTracker
  attr_reader :app, :headers, :selector

  def initialize(host: "localhost:3000", selector: "body")
    @app = ActionDispatch::Integration::Session.new(Rails.application)
    @headers = { "Host" => host }
    @selector = selector
  end

  def track_page_modifications
    load_content_pages.each_key do |path|
      response = request_path(path, app, headers)
      next if response.nil? || response.body.nil? || response.body.empty?

      document = Nokogiri::HTML(response.body).css(@selector)
      sanitized_document = sanitize_document(document)
      content_hash = hash_document(sanitized_document)
      page_mod = PageModification.find_or_initialize_by(path: path)

      if page_mod.new_record? || page_mod.content_hash != content_hash
        page_mod.update!(content_hash: content_hash)
      end
    end
  end

  private

  def load_content_pages
    ContentLoader.new.pages
  end

  def request_path(path, app, headers)
    app.host = @headers["Host"] unless app.host == @headers["Host"]
    app.get("/#{path}", headers: headers)
    redirected_path = app.response&.headers&.[]("Location")
    app.get("/#{redirected_path}", headers: headers) if redirected_path
    app.response
  end

  def sanitize_document(document)
    auth_token_input = document.at_css("form input[name='authenticity_token']")
    auth_token_input["value"] = "" if auth_token_input
    document
  end

  def hash_document(document)
    Digest::SHA1.hexdigest(document.to_s)
  end
end