# url https://preprod.teacher-qualifications-api.education.gov.uk/v3/person?include=RoutesToProfessionalStatuses
# header X-Api-Version: 20250905
# Authorization: Bearer <access token>

module TeacherAuth
  module Request
    class UserDetails
      attr_reader :token

      VERSION = "20250905".freeze

      def initialize(token)
        @token = token
      end

      def call
        response = HTTParty.get(
          ENV.fetch("TEACHER_AUTH_PERSON_URL", ""),
          headers: { "Authorization" => "Bearer #{token}", "X-Api-Version" => VERSION },
        )
        if response.ok?
          JSON.parse(response.body || "{}")
        else
          Rails.logger.error "status: #{response.code}, body: #{response.body}, headers: #{response.headers}"
          {}
        end
      end
    end
  end
end
