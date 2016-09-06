class ServiceManualHomepagePresenter < ContentItemPresenter
  def breadcrumbs
    []
  end

  def is_homepage?
    true
  end

  def topics
    unsorted_topics.sort_by { |topic| topic["title"] }
  end

private

  def unsorted_topics
    @_topics ||= links["children"] || []
  end
end
