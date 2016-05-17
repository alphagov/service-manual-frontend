require 'gds_api/content_store'
require 'slimmer/headers'

class ContentItemsController < ApplicationController
  include Slimmer::Headers
  rescue_from GdsApi::HTTPForbidden, with: :error_403

  def show
    set_slimmer_headers(
      search_parameters: {
        "filter_manual" => "/service-manual"
      }.to_json,
    )

    if load_content_item
      set_expiry
      set_locale
      render content_item_template
    else
      render text: 'Not found', status: :not_found
    end
  end

private

  def load_content_item
    content_item = content_store.content_item(content_item_path)
    @content_item = present(content_item) if content_item
  end

  def present(content_item)
    presenter_name = content_item['format'].classify + 'Presenter'
    presenter_class = Object.const_get(presenter_name)
    presenter_class.new(content_item)
  rescue NameError
    raise "No support for format \"#{content_item['format']}\""
  end

  def content_item_template
    @content_item.format
  end

  def set_expiry
    max_age = @content_item.content_item.cache_control.max_age
    cache_private = @content_item.content_item.cache_control.private?
    expires_in(max_age, public: !cache_private)
  end

  def set_locale
    I18n.locale = @content_item.locale || I18n.default_locale
  end

  def content_item_path
    '/' + URI.encode(params[:path])
  end

  def content_store
    @content_store ||= GdsApi::ContentStore.new(Plek.current.find("content-store"))
  end

private

  def error_403(exception)
    render text: exception.message, status: 403
  end
end
