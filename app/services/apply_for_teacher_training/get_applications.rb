module ApplyForTeacherTraining
  class GetApplications
    def call
      HTTParty.get(ENV.fetch('APPLICATION_API_URL'))
    end
  end
end