class TopicPresenter < ContentItemPresenter
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
      TopicPresenter::TopicGroup.new(group_data, linked_items)
    end
    topic_groups.select(&:present?)
  end

  def content_owners
    @content_owners ||= Array(content_item['links']['content_owners']).map do |data|
      ContentOwner.new(data['title'], data['base_path'])
    end
  end

  def email_alert_signup_link
    signups = content_item['links'].fetch('email_alert_signup', [])
    signups.first['base_path'] if signups.any?
  end

  def phase
    "beta"
  end

  def visually_collapsed?
    @visually_collapsed
  end

  def expanded?
    !visually_collapsed?
  end

  def display_as_accordion?
    groups.count > 1 && visually_collapsed?
  end

  def accordion_content
    # Each accordion needs a hash, as shown in the GOV.UK Publishing Components
    # guide: https://components.publishing.service.gov.uk/component-guide/accordion
    #
    # This method returns the content in the required shape from the hash
    # supplied by the `groups` method.
    #
    # The hash for each accordion section is required to have `name`,
    # `description`, and `linked_items`. Minimal example:
    # {
    #   name: 'Accordion section heading',
    #   description: 'Accordion section summary',
    #   linked_items: [
    #     {
    #       label: 'Link to example',
    #       href: 'http://example.com',
    #     }
    #   ],
    # }


    groups.map { |section|
      {
        heading: {
          text: section.name,
        },
        summary: {
          text: section.description,
        },
        content: {
          html: accordion_section_links(section.linked_items),
        },
        expanded: expanded?,
      }
    }
  end

private

  def accordion_section_links links
    # Expects `links` to be an array of hashes containing `href` and `label`
    # for the link. For example:
    #
    # ```ruby
    # [
    #   {
    #     label: 'Link to example',
    #     href: 'http://example.com'
    #   }
    # ]
    # ```
    #
    # This will return santitised HTML in a string. The above example would
    # return:
    #
    # ```html
    # <ul class="govuk-list">
    #   <li>
    #     <a href="http://example.com" class="govuk-link">Link to example</a>
    #   </li>
    # </ul>
    # ```

    links = links.map { |linked_item|
      link_html = ActionController::Base.helpers.link_to(linked_item.label, linked_item.href, class: 'govuk-link')
      "<li>#{link_html}</li>"
    }

    list = "<ul class=\"govuk-list\">#{links.join('')}</ul>"

    ActionController::Base.helpers.sanitize(list)
  end

  def parent_breadcrumbs
    [
      {
        title: 'Service manual',
        url: '/service-manual'
      }
    ]
  end

  def topic_breadcrumb
    { title: title }
  end
end
