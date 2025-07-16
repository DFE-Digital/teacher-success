module CookiesHelper
  def non_essential_cookies_preference
    teach_preferences_cookie.dig("non_essential")
  end

  def teach_preferences_cookie
    JSON.parse(cookies[CookiePreferencesController::PREFERENCES_COOKIE_NAME] || "{}")
  end

  alias_method :non_essential_cookies_accepted?, :non_essential_cookies_preference
end
