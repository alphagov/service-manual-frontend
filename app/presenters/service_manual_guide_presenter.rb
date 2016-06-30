class ServiceManualGuidePresenter < ContentItemPresenter
  ContentOwner = Struct.new(:title, :href)

  include ActionView::Helpers::DateHelper
  attr_reader :body, :publish_time, :header_links

  def initialize(content_item)
    super
    @body = details["body"]
    @header_links = Array(details["header_links"])
      .map { |h| ActiveSupport::HashWithIndifferentAccess.new(h) }
  end

  def content_owners
    links_content_owners_attributes.map do |content_owner_attributes|
      ContentOwner.new(content_owner_attributes["title"], content_owner_attributes["base_path"])
    end
  end

  def related_discussion
    if content_item["details"]["related_discussion"]
      discussion_data = content_item["details"]["related_discussion"]
      RelatedDiscussion.new(discussion_data['title'], discussion_data['href'])
    end
  end

  def last_published_time_in_words
    "#{time_ago_in_words(updated_at)} ago"
  end

  def last_published_time_timestamp
    updated_at.strftime("%e %B %Y %H:%M")
  end

  def category_title
    category["title"] if category.present?
  end

  def breadcrumbs
    crumbs = [{ title: "Service manual", url: "/service-manual" }]
    crumbs << { title: category["title"], url: category["base_path"] } if category
    crumbs << { title: content_item["title"] }
    crumbs
  end

  def show_description?
    !!details['show_description']
  end

private

  def updated_at
    DateTime.parse(content_item["updated_at"])
  end

  def links_content_owners_attributes
    content_item.to_hash.fetch('links', {}).fetch('content_owners', [])
  end

  def category
    topic || parent
  end

  def parent
    @_topic ||= Array(links["parent"]).first
  end

  def topic
    @_topic ||= Array(links["service_manual_topics"]).first
  end

  def links
    @_links ||= content_item["links"] || {}
  end

  def details
    @_details ||= content_item["details"] || {}
  end
end
