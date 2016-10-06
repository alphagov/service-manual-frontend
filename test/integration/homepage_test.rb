require 'test_helper'

class HomepageTest < ActionDispatch::IntegrationTest
  test 'the homepage displays the introductory text' do
    setup_and_visit_example('service_manual_homepage', 'service_manual_homepage')

    assert page.has_content? <<-TEXT
      Helping government teams create and run
      great digital services that meet the Digital Service Standard.
    TEXT
  end

  test 'the homepage includes a feedback link' do
    setup_and_visit_example('service_manual_homepage', 'service_manual_homepage')

    assert page.has_content?(
      "Contact the service manual team with any comments or questions."
    )

    assert page.has_link? 'service manual team', href: '/contact/govuk'
  end

  test 'the homepage includes the titles and descriptions of associated topics' do
    setup_and_visit_example('service_manual_homepage', 'service_manual_homepage')

    assert page.has_content? "Agile delivery How to work in an agile way: principles, tools and governance."
    assert page.has_link? 'Agile delivery', href: '/service-manual/agile-delivery'
  end

  test 'the homepage includes a link to the digital service standard' do
    setup_and_visit_example('service_manual_homepage', 'service_manual_homepage')

    assert page.has_content? <<-TEXT
      The Digital Service Standard provides the principles of building a good
      digital service. This manual explains what teams can do to build great
      digital services that will meet the standard.
    TEXT

    assert page.has_link? 'Digital Service Standard', href: '/service-manual/service-standard'
  end

  test 'the homepage includes a link to the communities of practise' do
    setup_and_visit_example('service_manual_homepage', 'service_manual_homepage')

    assert page.has_content? <<-TEXT
      You can view the communities of practice to find more learning
      resources, see who has written the guidance in the manual and connect
      with digital people like you from across government.
    TEXT

    assert page.has_link? 'communities of practice', href: '/service-manual/communities'
  end
end
