module CookiesHelper
  def non_essential_cookies_accepted?
    teach_preferences_cookie.dig("nonEssential")
  end

  def teach_preferences_cookie
    JSON.parse(cookies["teach_preferences"] || "{}")
  end
end
