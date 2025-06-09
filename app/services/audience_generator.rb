require "csv"

class AudienceGenerator
  def initialize(filepath: "audience.csv", data: nil)
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

  def fetch_data
    CandidatesApiClient.new
      .candidates
      .with_application_status(statuses: [ "recruited", "pending_conditions" ])
      .with_recruitment_cycle_year(year: 2024)
  end
end
