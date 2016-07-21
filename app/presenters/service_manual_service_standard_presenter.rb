class ServiceManualServiceStandardPresenter < ContentItemPresenter
  def points
    Point.load(points_attributes).sort
  end

  def breadcrumbs
    [
      { title: "Service manual", url: "/service-manual" },
      { title: title }
    ]
  end

private

  def points_attributes
    @_points_attributes ||= links["children"] || []
  end

  def links
    @_links ||= content_item["links"] || {}
  end

  class Point
    include Comparable

    attr_reader :title, :description, :base_path

    def self.load(points_attributes)
      points_attributes.map { |point_attributes| new(point_attributes) }
    end

    def initialize(attributes)
      @title = attributes["title"]
      @description = attributes["description"]
      @base_path = attributes["base_path"]
    end

    def <=>(other)
      number <=> other.number
    end

    def number
      @_number ||= Integer(title.scan(/\A(\d*)/)[0][0])
    end
  end
end
