require "csv"

class AudienceGenerator
  def initialize(filepath: "audience_#{Rails.env}_#{Date.current.to_s}.csv", data: nil)
    @filepath = filepath
    @data = data || fetch_data
  end

  def export
    CSV.open(@filepath, "w") do |csv|
      csv << %w[
      id
      email
      first_name
      last_name
      recruitment_cycle_year
      application_status
      ]

      @data.each do |candidate|
        csv << [
          candidate.dig("id"),
          candidate.dig("attributes", "email_address"),
          candidate.dig("attributes", "application_forms", -1, "first_name"),
          candidate.dig("attributes", "application_forms", -1, "last_name"),
          candidate.dig("attributes", "application_forms", -1, "recruitment_cycle_year"),
          candidate.dig("attributes", "application_forms", -1, "application_status")
        ]
      end
    end
  end

  private

  def fetch_data(query: { page: 1, per_page: 500, updated_since: Date.current - 2.years })
    return enum_for(:fetch_data, query: query) unless block_given?

    page = 1

    loop do
      paginated_query = query.merge(page: page)

      begin
        candidates = CandidatesApiClient.new
          .candidates(query: paginated_query)
          .with_application_status(statuses: [ "recruited", "pending_conditions" ])
          .with_recruitment_cycle_year(year: 2024)

        candidates.each { |candidate| yield candidate }
      rescue PageParameterInvalidError
        # This is fine, we got to the end of the pagination
        puts "Exported audience to #{@filepath}"
        break
      end

      page += 1
    end
  end
end
