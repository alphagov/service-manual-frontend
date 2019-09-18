require 'test_helper'

class TopicTest < ActionDispatch::IntegrationTest
  setup do
    @topic_example = JSON.parse(
      GovukContentSchemaTestHelpers::Examples.new.get(
        'service_manual_topic',
        'service_manual_topic',
      )
    )
  end

  test "it uses topic description as meta description" do
    content_store_has_item("/service-manual/test-topic", @topic_example.to_json)

    visit "/service-manual/test-topic"

    assert page.has_css?('meta[name="description"]', visible: false)
    tag = page.find 'meta[name="description"]', visible: false
    assert_equal @topic_example["description"], tag["content"]
  end

  test "it doesn't write a meta description if there is none" do
    @topic_example.delete("description")
    content_store_has_item("/service-manual/test-topic", @topic_example.to_json)

    visit "/service-manual/test-topic"

    refute page.has_css?('meta[name="description"]', visible: false)
  end

  test "it lists communities in the sidebar" do
    setup_and_visit_example('service_manual_topic', 'service_manual_topic')

    within('.related-communities') do
      assert page.has_link?("Agile delivery community",
                            href: "/service-manual/communities/agile-delivery-community")
      assert page.has_link?("User research community",
                            href: "/service-manual/communities/user-research-community")
    end
  end

  test "it includes a link to subscribe for email alerts" do
    setup_and_visit_example('service_manual_topic', 'service_manual_topic')

    assert page.has_link?("email",
                          href: "/service-manual/test-expanded-topic/email-signup")
  end
end
