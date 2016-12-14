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
end
