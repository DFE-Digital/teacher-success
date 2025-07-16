class CookiePreferencesController < ApplicationController
  COOKIE_NAME = "teach_preferences".freeze

  def edit
    @preferences = teach_preferences_cookie


  end

  def update
    preferences = {
      nonEssential: params[:non_essential] == "1"
    }

    cookies[COOKIE_NAME] = {
      value: preferences.to_json,
      path: "/",
      expires: 90.days.from_now,
      httponly: false
    }

    flash = {
      title: "Success",
      heading: "Cookie Preferences Updated",
      description: "Your cookie preferences have been saved."
    }

    redirect_to cookie_preferences_path, flash: { success: flash }
  end
end

