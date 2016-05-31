require 'test_helper'
require 'slimmer/test_helpers/shared_templates'

class ContentItemsControllerTest < ActionController::TestCase
  include GdsApi::TestHelpers::ContentStore
  include Slimmer::TestHelpers::SharedTemplates

  test "routing handles translated content paths" do
    translated_path = 'government/case-studies/allez.fr'

    assert_routing({ path: translated_path, method: :get },
      controller: 'content_items', action: 'show', path: translated_path)
  end

  test "gets item from content store" do
    content_item = content_store_has_schema_example('service_manual_guide', 'service_manual_guide')

    get :show, path: path_for(content_item)
    assert_response :success
    assert_equal content_item['title'], assigns[:content_item].title
  end

  test "sets the expiry as sent by content-store" do
    content_item = content_store_has_schema_example('service_manual_guide', 'service_manual_guide')
    content_store_has_item(content_item['base_path'], content_item, max_age: 20)

    get :show, path: path_for(content_item)
    assert_response :success
    assert_equal "max-age=20, public", @response.headers['Cache-Control']
  end

  test "honours cache-control private items" do
    content_item = content_store_has_schema_example('service_manual_guide', 'service_manual_guide')
    content_store_has_item(content_item['base_path'], content_item, private: true)

    get :show, path: path_for(content_item)
    assert_response :success
    assert_equal "max-age=900, private", @response.headers['Cache-Control']
  end

  test "gets item from content store even when url contains multi-byte UTF8 character" do
    content_item = content_store_has_schema_example('service_manual_guide', 'service_manual_guide')
    utf8_path    = "government/case-studies/caf\u00e9-culture"
    content_item['base_path'] = "/#{utf8_path}"

    content_store_has_item(content_item['base_path'], content_item)

    get :show, path: utf8_path
    assert_response :success
  end

  test "returns 404 for item not in content store" do
    path = 'government/case-studies/boost-chocolate-production'

    content_store_does_not_have_item('/' + path)

    get :show, path: path
    assert_response :not_found
  end

  test "returns 403 for access-limited item" do
    path = 'government/case-studies/super-sekrit-document'
    url = CONTENT_STORE_ENDPOINT + "/content/" + path
    stub_request(:get, url).to_return(status: 403, headers: {})

    get :show, path: path
    assert_response :forbidden
  end

  test 'renders service manual guides' do
    content_item = content_store_has_schema_example('service_manual_guide', 'service_manual_guide')

    get :show, path: path_for(content_item)
    assert_response :success
    assert_equal content_item['title'], assigns[:content_item].title
  end

  def path_for(content_item)
    content_item['base_path'].sub(/^\//, '')
  end
end
