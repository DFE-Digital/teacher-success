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

group :development, :test do
  gem "debug", platforms: %i[ mri windows ], require: "debug/prelude"
  gem "brakeman", require: false
  gem "rubocop-rails-omakase", require: false
  gem "rspec"
  gem "rspec-rails"
  gem "bundler-audit"
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
