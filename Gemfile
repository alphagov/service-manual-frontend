source "https://rubygems.org"

gem "rails", "7.0.4.1"

gem "bootsnap", require: false
gem "gds-api-adapters"
gem "govuk_app_config"
gem "govuk_publishing_components"
gem "mail", "~> 2.7.1" # TODO: remove once https://github.com/mikel/mail/issues/1489 is fixed.
gem "plek"
gem "rails-i18n"
gem "sassc-rails"
gem "slimmer"
gem "sprockets-rails"
gem "uglifier"

group :development, :test do
  gem "govuk_test"
  gem "rubocop-govuk"
end

group :development do
  gem "better_errors"
  gem "binding_of_caller"
  gem "listen"
end

group :test do
  gem "capybara"
  gem "govuk_schemas"
  gem "pry-byebug"
  gem "rails-controller-testing"
  gem "simplecov"
  gem "webmock", require: false
end
