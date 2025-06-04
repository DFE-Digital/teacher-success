class CandidatesCollection
  include Enumerable

  def initialize(data)
    @candidates = data
  end

  def each(&block)
    @candidates.each(&block)
  end

  def with_application_status(statuses: ["recruited"])
    candidates = @candidates.filter do |candidate|
      application_forms = candidate.dig("attributes", "application_forms") || []
      application_forms.any? { |form| statuses.include?(form["application_status"]) }
    end

    self.class.new(candidates)
  end

  def with_recruitment_cycle_year(year:)
    candidates = @candidates.filter do |candidate|
      application_forms = candidate.dig("attributes", "application_forms") || []
      application_forms.any? { it.dig("recruitment_cycle_year") == year }
    end

    self.class.new(candidates)
  end
end
