class Admin::MissionControlController < ApplicationController
  http_basic_authenticate_with(
    name: ENV["MISSION_CONTROL_NAME"],
    password: ENV["MISSION_CONTROL_PASSWORD"]
  )
end
