require 'gds_api/test_helpers/content_store'

# Include this module to get access to the GOVUK Content Schema examples in the
# tests.
#
# By default, the govuk-content-schemas repository is expected to be located
# at ../govuk-content-schemas. This can be overridden with the
# GOVUK_CONTENT_SCHEMAS_PATH environment variable, for example:
#
#   $ GOVUK_CONTENT_SCHEMAS_PATH=/some/dir/govuk-content-schemas bundle exec rake
#
# Including this module will automatically stub out all the available examples
# with the content store.

GovukContentSchemaTestHelpers.configure do |config|
  config.schema_type = 'frontend'
  config.project_root = Rails.root
end

module GovukContentSchemaExamples
  extend ActiveSupport::Concern

  included do
    include GdsApi::TestHelpers::ContentStore
  end

  def content_store_has_schema_example(schema_name, example_name)
    document = govuk_content_schema_example(schema_name, example_name)
    content_store_has_item(document['base_path'], document)
    document
  end

  def govuk_content_schema_example(schema_name, example_name, overrides = {})
    JSON.parse(
      GovukContentSchemaTestHelpers::Examples.new.get(schema_name, example_name)
    ).deep_merge(overrides.stringify_keys)
  end

  module ClassMethods
    def all_examples_for_supported_formats
      GovukContentSchemaTestHelpers::Examples.new.get_all_for_formats(supported_formats).map do |string|
        JSON.parse(string)
      end
    end

    def supported_formats
      %w{
        service_manual_guide
        service_manual_homepage
        service_manual_service_standard
        service_manual_topic
      }
    end
  end
end
