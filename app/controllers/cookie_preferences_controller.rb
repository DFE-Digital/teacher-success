class CookiePreferencesController < ApplicationController
  PREFERENCES_COOKIE_NAME = "teach_preferences".freeze

  def edit
    @front_matter = { page_header: { title: "Cookies policy" } }
    @preferences = CookiePreferences.new(cookie: cookies[PREFERENCES_COOKIE_NAME])
    breadcrumb "Cookies policy", edit_cookie_preferences_path
  end

  def update
    non_essential_preference = params.dig("cookie_preferences", "non_essential")

    set_preferences({
      non_essential: ActiveRecord::Type::Boolean.new.deserialize(non_essential_preference)
    })

    if URI(request.referer || "").path == edit_cookie_preferences_path
      # Only set a flash if we're updating from the cookie_preferences/edit page
      # If we're coming from the home page, dismissing the banner is enough
      flash[:success] = {
        title: "Success",
        heading: "Cookie Preferences Updated",
        description: "Your cookie preferences have been saved."
      }
    end

    redirect_to request.referer || root_path
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
