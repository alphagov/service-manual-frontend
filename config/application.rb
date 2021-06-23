require_relative "boot"

require "rails"
# Pick the frameworks you want:
require "active_model/railtie"
require "active_job/railtie"
# require "active_record/railtie"
# require "active_storage/engine"
require "action_controller/railtie"
require "action_mailer/railtie"
# require "action_mailbox/engine"
# require "action_text/engine"
require "action_view/railtie"
# require "action_cable/engine"
require "sprockets/railtie"
require "rails/test_unit/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module ServiceManualFrontend
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 6.1

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.

    # Explicitly set default locale
    config.i18n.default_locale = :en

    # Explicitly set available locales
    config.i18n.available_locales = [
      :en,
      :ar,
      :az,
      :be,
      :bg,
      :bn,
      :cs,
      :cy,
      :de,
      :dr,
      :el,
      :es,
      "es-419",
      :et,
      :fa,
      :fr,
      :he,
      :hi,
      :hu,
      :hy,
      :id,
      :it,
      :ja,
      :ka,
      :ko,
      :lt,
      :lv,
      :ms,
      :pl,
      :ps,
      :pt,
      :ro,
      :ru,
      :si,
      :sk,
      :so,
      :sq,
      :sr,
      :sw,
      :ta,
      :th,
      :tk,
      :tr,
      :uk,
      :ur,
      :uz,
      :vi,
      :zh,
      "zh-hk",
      "zh-tw",
    ]

    # Path within public/ where assets are compiled to
    config.assets.prefix = "/assets/service-manual-frontend"

    # Using a sass css compressor causes a scss file to be processed twice
    # (once to build, once to compress) which breaks the usage of "unquote"
    # to use CSS that has same function names as SCSS such as max.
    # https://github.com/alphagov/govuk-frontend/issues/1350
    config.assets.css_compressor = nil

    # allow overriding the asset host with an enironment variable, useful for
    # when router is proxying to this app but asset proxying isn't set up.
    config.asset_host = ENV["ASSET_HOST"]
  end
end
