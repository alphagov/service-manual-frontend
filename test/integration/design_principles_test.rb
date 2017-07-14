require 'test_helper'

class DesignPrinciplesTest < ActionDispatch::IntegrationTest
  test "designprinciples page should render without blowing up" do
    visit "/design-principles"

    assert page.has_content?("Design Principles")
    assert page.has_content?("Start with user needs")
  end

  test "accessible PDFs page should render" do
    visit "/design-principles/accessiblepdfs"
    assert page.has_content?("Accessible PDFs")
  end

  test "performance framework page should render" do
    visit "/design-principles/performanceframework"
    assert page.has_content?("Performance Framework")
  end
end

