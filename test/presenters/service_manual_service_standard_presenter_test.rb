require 'test_helper'

class ContentItemPresenterTest < ActiveSupport::TestCase
  test "#points gets points from the details" do
    example = GovukContentSchemaTestHelpers::Examples.new.get(
      'service_manual_service_standard',
      'service_manual_service_standard'
    )

    points = ServiceManualServiceStandardPresenter.new(JSON.parse(example)).points

    assert points.any? { |point_hash| point_hash.title == "1. Understand user needs" }
    assert points.any? { |point_hash| point_hash.title == "2. Do ongoing user research" }
  end

  test "#points returns points ordered numerically" do
    content_item_hash = {
      "links" => {
        "children" => [
          { "title" => "3. Title" },
          { "title" => "1. Title" },
          { "title" => "9. Title" },
          { "title" => "10. Title" },
          { "title" => "5. Title" },
          { "title" => "6. Title" },
          { "title" => "2. Title" },
          { "title" => "4. Title" },
          { "title" => "7. Title" },
          { "title" => "11. Title" },
          { "title" => "8. Title" },
        ]
      }
    }

    points_titles =
      ServiceManualServiceStandardPresenter.new(content_item_hash).points.map(&:title)

    assert_equal points_titles, [
      "1. Title",
      "2. Title",
      "3. Title",
      "4. Title",
      "5. Title",
      "6. Title",
      "7. Title",
      "8. Title",
      "9. Title",
      "10. Title",
      "11. Title",
    ]
  end

  test "#points is empty if there aren't any points in the content item" do
    assert ServiceManualServiceStandardPresenter.new({}).points.empty?
  end

  test "#breadcrumbs contains a link to the service manual root" do
    content_item_hash = {
      "title" => "Digital Service Standard"
    }

    assert ServiceManualServiceStandardPresenter.new(content_item_hash).breadcrumbs,
      [
        { title: "Service manual", url: "/service-manual" },
        { title: "Digital Service Standard" },
      ]
  end
end
