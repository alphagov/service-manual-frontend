source 'https://rubygems.org'

ruby File.read('.ruby-version').strip

gem 'gds-api-adapters', '~> 59.2.1'
gem 'govuk_app_config', '~> 1.16'
gem 'govuk_elements_rails'
gem 'govuk_frontend_toolkit', '~> 8.2.0'
gem 'govuk_publishing_components', '~> 16.26.0'
gem 'plek', '2.1.1'
gem 'rails', '~> 5.2.3'
gem 'rails-i18n', '~> 5.1.3'
gem 'rails_translation_manager', '~> 0.1.0'
gem 'sass-rails', '~> 5.0.6'
gem 'slimmer', '~> 13.1.0'
gem 'uglifier', '>= 1.3.0'

group :development, :test do
  gem 'govuk-lint'
  gem 'jasmine-rails'
  gem 'phantomjs', '~> 2.1.1'
end

group :development do
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'web-console', '~> 3.7'
  gem 'wraith', '~> 4.2'
end

group :test do
  gem 'capybara'
  gem 'govuk-content-schema-test-helpers', '~> 1.6'
  gem 'poltergeist'
  gem 'pry-byebug'
  gem 'rails-controller-testing'
  gem 'webmock', '~> 3.5.1', require: false
end
