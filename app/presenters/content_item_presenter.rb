class ContentItemPresenter
  attr_reader :content_item, :title, :description, :format, :locale, :phase, :links

  def initialize(content_item)
    @content_item = content_item
    @title = content_item["title"]
    @description = content_item["description"]
    @format = content_item["format"]
    @locale = content_item["locale"] || "en"
    @phase = content_item["phase"]
    @links = content_item["links"] || {}
  end

  def available_translations
    sorted_locales(links["available_translations"])
  end

  def is_homepage?
    false
  end

private

  def display_time(timestamp)
    I18n.l(Date.parse(timestamp), format: "%-d %B %Y") if timestamp
  end

  def sorted_locales(translations)
    translations.sort_by { |t| t["locale"] == I18n.default_locale.to_s ? '' : t["locale"] }
  end
end
