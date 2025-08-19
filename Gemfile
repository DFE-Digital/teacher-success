source "https://rubygems.org"

gem "rails", "~> 8.0.2"
gem "propshaft"
gem "pg"
gem "puma"
gem "jsbundling-rails"
gem "turbo-rails"
gem "stimulus-rails"
gem "cssbundling-rails"
gem "tzinfo-data", platforms: %i[ windows jruby ]
gem "bootsnap", require: false
gem "thruster", require: false
gem "govuk-components"
gem "govuk_design_system_formbuilder"
gem "front_matter_parser"
gem "govuk_markdown"
gem "httparty"
gem "dotenv"
gem "view_component"
gem "loaf"
gem "pagy"
gem "solid_queue"
gem "mission_control-jobs"
gem "validate_url"
gem "sentry-ruby"
gem "sentry-rails"
gem "active_link_to"
gem "dfe-analytics", github: "DFE-Digital/dfe-analytics", tag: "v1.15.7"

group :development, :test do
  gem "debug", platforms: %i[ mri windows ], require: "debug/prelude"
  gem "brakeman", require: false
  gem "rubocop-rails-omakase", require: false
  gem "rspec"
  gem "rspec-rails"
  gem "bundler-audit"
  gem "factory_bot_rails"
end

group :development do
  gem "web-console"
end

group :test do
  gem "capybara"
  gem "selenium-webdriver"
  gem "simplecov", require: false
  gem "webmock"
end
