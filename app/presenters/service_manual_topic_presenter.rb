class ServiceManualTopicPresenter < ContentItemPresenter
  ContentOwner = Struct.new(:title, :href)

  def initialize(content_item)
    super
    @visually_collapsed = content_item["details"]["visually_collapsed"]
  end

  def breadcrumbs
    parent_breadcrumbs << topic_breadcrumb
  end

  def groups
    linked_items = content_item['links']['linked_items']
    topic_groups = Array(content_item['details']['groups']).map do |group_data|
      ServiceManualTopicPresenter::TopicGroup.new(group_data, linked_items)
    end
    topic_groups.select(&:present?)
  end

  def content_owners
    @content_owners ||= Array(content_item['links']['content_owners']).map do |data|
      ContentOwner.new(data['title'], data['base_path'])
    end
  end

  def phase
    "beta"
  end

  def visually_collapsed?
    @visually_collapsed
  end

private

  def topic_breadcrumb
    { title: title }
  end

  def parent_breadcrumbs
    [
      {
        title: 'Service manual',
        url: '/service-manual'
      }
    ]
  end
end
