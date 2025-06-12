class CandidatesApiClient
  include HTTParty

  base_uri ENV["CANDIDATE_API_BASE_URI"]

  def initialize
    @headers = { "Authorization" => "Bearer #{ENV["CANDIDATE_API_ACCESS_TOKEN"]}" }
  end

  def candidates(query: { page: 1, per_page: 500, updated_since: Date.current - 1.year })
    response = self.class.get("/candidates", query: query, headers: @headers)
    response = handle_response(response)

    CandidatesCollection.new(response.parsed_response["data"])
  end

  private

  def handle_response(response)
    return response if response.success?

    raise(ParameterMissingError, response.parsed_response) if response.body.match?(/ParameterMissing/)
    raise(PageParameterInvalidError, response.parsed_response) if response.body.match?(/PageParameterInvalid/)
    raise(StandardError, response.parsed_response)
  end
end
