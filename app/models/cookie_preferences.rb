class CookiePreferences
  include ActiveModel::Model
  include ActiveModel::Attributes

  attr_accessor :cookie, :non_essential

  def initialize(cookie:)
    @cookie = JSON.parse(cookie) rescue {}
    @non_essential = @cookie.dig("non_essential")
  end
end
