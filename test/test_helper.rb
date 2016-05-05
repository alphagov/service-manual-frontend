ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require 'webmock/minitest'
require 'support/govuk_content_schema_examples'
require 'capybara/rails'
require 'capybara/poltergeist'
require 'slimmer/test_helpers/shared_templates'

class ActiveSupport::TestCase
  include GovukContentSchemaExamples
end

# Note: This is so that slimmer is skipped, preventing network requests for
# content from static (i.e. core_layout.html.erb).
class ActionController::Base
  before_filter proc {
    response.headers[Slimmer::Headers::SKIP_HEADER] = "true" unless ENV["USE_SLIMMER"]
  }
end

Capybara.default_driver = :rack_test
Capybara.javascript_driver = :poltergeist

class ActionDispatch::IntegrationTest
  # Make the Capybara DSL available in all integration tests
  include Capybara::DSL
  include Slimmer::TestHelpers::SharedTemplates

  # When running JS tests with Capybara the app and the test runner run
  # in separate threads. Capybara shoots off http://localhost:<some port>/__identify__
  # requests to see if the app is ready. We don't want Webmock to block
  # these requests because the test suite will never run but we also don't
  # want to allow all localhost requests because we run these tests on VMs that
  # run a lot of services that might give us a false positive.
  driver_requests = %r{/__identify__$}
  WebMock.disable_net_connect! allow: driver_requests

  def after_teardown
    super
    Capybara.use_default_driver
  end

  def assert_has_component_metadata_pair(label, value)
    within shared_component_selector("metadata") do
      # Flatten top level / "other" args, for consistent hash access
      component_args = JSON.parse(page.text).tap do |args|
        args.merge!(args.delete("other"))
      end
      assert_equal value, component_args.fetch(label)
    end
  end

  def assert_has_component_title(title)
    within shared_component_selector("title") do
      assert_equal title, JSON.parse(page.text).fetch("title")
    end
  end

  def assert_has_component_govspeak(content, index: 1)
    within_component_govspeak(index: index) do
      assert_equal content, JSON.parse(page.text).fetch("content")
    end
  end

  def within_component_govspeak(index: 1)
    within(shared_component_selector("govspeak") + ":nth-of-type(#{index})") do
      component_args = JSON.parse(page.text)
      yield component_args
    end
  end

  def assert_has_component_breadcrumbs(breadcrumbs)
    within shared_component_selector("breadcrumbs") do
      assert_equal breadcrumbs, JSON.parse(page.text).deep_symbolize_keys.fetch(:breadcrumbs)
    end
  end

  def assert_has_contents_list(contents)
    assert page.has_css?(".dash-list"), "Failed to find an element with a class of dash-list"
    within ".dash-list" do
      contents.each do |heading|
        selector = "a[href=\"##{heading[:id]}\"]"
        text = heading.fetch(:text)
        assert page.has_css?(selector), "Failed to find an element matching: #{selector}"
        assert page.has_css?(selector, text: text), "Failed to find an element matching #{selector} with text: #{text}"
      end
    end
  end

  def setup_and_visit_content_item(name)
    @content_item = JSON.parse(get_content_example(name)).tap do |item|
      content_store_has_item(item["base_path"], item.to_json)
      visit item["base_path"]
    end
  end

  def get_content_example(name)
    get_content_example_by_format_and_name(schema_format, name)
  end

  def get_content_example_by_format_and_name(format, name)
    GovukContentSchemaTestHelpers::Examples.new.get(format, name)
  end

  # Override this method if your test file doesn't match the convention
  def schema_format
    self.class.to_s.gsub('Test', '').underscore
  end
end
