class ServiceManualHomepagePresenter < ContentItemPresenter
  def breadcrumbs
    []
  end

  def topics
    unsorted_topics.sort_by { |topic| topic["title"] }
  end

private

  def unsorted_topics
    @_topics ||= links["children"] || []
  end
end
