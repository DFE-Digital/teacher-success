class RobotsController < ApplicationController
  def show
    if Rails.env.production?
      render plain: <<~ROBOTS
        User-agent: *
        Allow: /$
        Disallow: /
      ROBOTS

    else
      render plain: <<~ROBOTS
        User-agent: *
        Disallow: /
      ROBOTS
    end
  end
end
