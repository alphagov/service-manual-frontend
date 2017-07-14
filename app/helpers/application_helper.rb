module ApplicationHelper
  def page_text_direction
    I18n.t("i18n.direction", locale: I18n.locale, default: "ltr")
  end

  def wrapper_class
    "direction-#{page_text_direction}" if page_text_direction
  end

  def contact_govuk_path
    "/contact/govuk"
  end

  def digital_guidance_path
    "/topic/government-digital-guidance/content-publishing"
  end
end
