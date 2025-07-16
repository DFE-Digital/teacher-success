class CookiePreferencesController < ApplicationController
  PREFERENCES_COOKIE_NAME = "teach_preferences".freeze

  def edit
    @front_matter = { page_header: { title: "Cookie preferences" } }
    @preferences = JSON.parse(cookies[PREFERENCES_COOKIE_NAME])
    breadcrumb "Cookies preferences", edit_cookie_preferences_path
  end

  def update
    set_preferences({
      non_essential: ActiveRecord::Type::Boolean.new.deserialize(params[:non_essential])
    })

    flash = {
      title: "Success",
      heading: "Cookie Preferences Updated",
      description: "Your cookie preferences have been saved."
    }

    redirect_to root_path, flash: { success: flash }
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
