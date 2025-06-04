class CandidatesApiClient
  include HTTParty

  base_uri ENV["CANDIDATE_API_BASE_URI"]

  def initialize
    @headers = { "Authorization" => "Bearer #{ENV["CANDIDATE_API_ACCESS_TOKEN"]}" }
  end

  def candidates
    query = { updated_since: Date.current - 1.year }
    res = self.class.get("/candidates", query: query, headers: @headers)

    CandidatesCollection.new(res.parsed_response["data"])
  end

  private

  def handle_response(response)
    if response.success?
      response.parsed_response["data"]
    else
      raise StandardError, response.parsed_response
    end
  end
end
