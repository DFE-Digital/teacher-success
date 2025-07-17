class CookiePreferencesController < ApplicationController
  PREFERENCES_COOKIE_NAME = "teach_preferences".freeze

  def edit
    @front_matter = { page_header: { title: "Cookie preferences" } }
    @preferences = CookiePreferences.new(cookie: cookies[PREFERENCES_COOKIE_NAME])
    breadcrumb "Cookies preferences", edit_cookie_preferences_path
  end

  def update
    non_essential_preference = params.dig("cookie_preferences", "non_essential")

    set_preferences({
      non_essential: ActiveRecord::Type::Boolean.new.deserialize(non_essential_preference)
    })

    flash = {
      title: "Success",
      heading: "Cookie Preferences Updated",
      description: "Your cookie preferences have been saved."
    }

    redirect_to edit_cookie_preferences_path, flash: { success: flash }
  end

  private

  def set_preferences(preferences)
    cookies[PREFERENCES_COOKIE_NAME] = {
      value: preferences.to_json,
      path: "/",
      expires: 90.days.from_now,
      httponly: false
    }
  end
end
