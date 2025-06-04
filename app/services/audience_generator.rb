require 'csv'

class AudienceGenerator
  def initialize(filepath="audience.csv")
    @filepath = filepath
    @data = data
  end

  def data
    CandidatesApiClient.new
      .candidates.with_application_status(statuses: ["recruited", "pending_conditions"])
      .with_recruitment_cycle_year(year: 2024)
  end

  def export
    CSV.open(@filepath, "w") do |csv|
      csv << %w(id email)

      @data.each do |candidate|
        csv << [
          candidate.dig("id"),
          candidate.dig("attributes", "email_address"),
        ]
      end
    end
  end
end
