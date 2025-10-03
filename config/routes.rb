Rails.application.routes.draw do
  # DFE Custom events
  post "events", to: "events#create"

  # Cookie Preferences
  resource :cookie_preferences, only: [ :edit, :update ]
  get "cookies", to: "cookie_preferences#edit", as: "cookies"

  # Feedback
  get  "feedback",      to: "feedback#index", as: "feedback"
  get  "feedback/new",  to: "feedback#new",   as: "new_feedback"
  post "feedback",      to: "feedback#create"
  get  "page_feedback", to: "page_feedback#index"
  post "page_feedback", to: "page_feedback#create"

  # Sitemap
  get "/sitemap", to: "sitemap#index"

  # DfE Sign-in
  get "/sign-in", to: "sessions#new", as: :sign_in
  get "/account", to: "account#index", as: :account

  if ENV.fetch("SIGN_IN_METHOD", "persona") == "persona"
    get "/personas", to: "personas#index"
    get "/auth/developer/sign-out", to: "sessions#destroy", as: :sign_out
    post "/auth/developer/callback", to: "sessions#callback", as: :auth_callback
  else
    get "/auth/govuk_one_login/callback" => "sessions#callback", as: :one_login_callback
    get "/auth/govuk_one_login/identify", to: "sessions#identify", as: :one_login_identify

    # get "/auth/teacher_auth/callback", to: "sessions#teacher_auth", as: :teacher_auth_callback


    get "/auth/govuk_one_login/sign-out" => "sessions#destroy", as: :sign_out
    get "/auth/failure", to: "sessions#failure"
  end

  mount MissionControl::Jobs::Engine, at: "/jobs"

  # Errors
  scope via: :all do
    get "/404", to: "errors#not_found"
    get "/422", to: "errors#unprocessable_entity"
    get "/429", to: "errors#too_many_requests"
  end
  match "/500", to: "errors#internal_server_error", via: :all, as: :internal_server_error

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Keep this last to route any other paths to the show controller and render 404s if not found
  get "/*slug", to: "content#show"

  # Root to home page
  root to: "content#show", defaults: { slug: "home" }
end
