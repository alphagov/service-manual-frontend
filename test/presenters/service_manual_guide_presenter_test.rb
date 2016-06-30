require 'test_helper'

class ServiceManualGuidePresenterTest < ActiveSupport::TestCase
  test 'presents the basic details required to display a Service Manual Guide' do
    assert_equal "Agile Delivery", presented_guide.title
    assert_equal "service_manual_guide", presented_guide.format
    assert presented_guide.body.size > 10
    assert presented_guide.header_links.size >= 1

    content_owner = presented_guide.content_owners.first
    assert content_owner.title.present?
    assert content_owner.href.present?
  end

  test '#last_published_time_in_words outputs a human readable definition of time ago' do
    guide = presented_guide('updated_at' => 1.year.ago.iso8601)
    assert_equal 'about 1 year ago', guide.last_published_time_in_words
  end

  test '#last_published_time_timestamp outputs a nicely formatted timestamp' do
    guide = presented_guide('updated_at' => '2014-10-26T10:27:34Z')
    assert_equal '26 October 2014 10:27', guide.last_published_time_timestamp
  end

  test 'breadcrumbs have a root and a topic link' do
    guide = presented_guide
    assert_equal [
                   { title: "Service manual", url: "/service-manual" },
                   { title: "Agile", url: "/service-manual/agile" },
                   { title: "Agile Delivery" },
                 ],
                 guide.breadcrumbs
  end

  test "breadcrumbs gracefully omit topic if it's not present" do
    presented_guide = presented_guide("links" => {})
    assert_equal [
                   { title: "Service manual", url: "/service-manual" },
                   { title: "Agile Delivery" },
                 ],
                 presented_guide.breadcrumbs
  end

  test "#category_title is the title of the category" do
    guide = presented_guide
    assert_equal 'Agile', guide.category_title
  end

  test "#category_title is the title of the parent for a point" do
    example = GovukContentSchemaTestHelpers::Examples.new.get(
      'service_manual_guide',
      'point_page'
    )

    presenter = ServiceManualGuidePresenter.new(JSON.parse(example))

    assert presenter.category_title, "The Digital Service Standard"
  end

  test "#category_title can be empty" do
    guide = presented_guide("links" => {})
    assert_nil guide.category_title
  end

  test '#content_owners when stored in the links' do
    guide = presented_guide(
      'details' => { 'content_owner' => nil },
      'links' => { 'content_owners' => [{
        "content_id" => "e5f09422-bf55-417c-b520-8a42cb409814",
        "title" => "Agile delivery community",
        "base_path" => "/service-manual/communities/agile-delivery-community",
      }] }
    )

    expected = [
      ServiceManualGuidePresenter::ContentOwner.new(
        "Agile delivery community",
        "/service-manual/communities/agile-delivery-community")
    ]
    assert_equal expected, guide.content_owners
  end

  test "#show_description? is false if not set" do
    refute ServiceManualGuidePresenter.new({}).show_description?
  end

private

  def presented_guide(overriden_attributes = {})
    ServiceManualGuidePresenter.new(
      JSON.parse(GovukContentSchemaTestHelpers::Examples.new.get('service_manual_guide', 'service_manual_guide')).merge(overriden_attributes)
    )
  end
end
