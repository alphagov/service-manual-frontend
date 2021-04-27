Rails.application.routes.draw do
  mount GovukPublishingComponents::Engine, at: "/component-guide"

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  mount JasmineRails::Engine => "/specs" if defined?(JasmineRails)

  get "/service-manual/search",
      to: redirect { |_, request|
            query = request.query_parameters.merge(filter_manual: "/service-manual").to_query
            "/search?#{query}"
          }

  with_options format: false do |r|
    r.get "healthcheck/live", to: proc { [200, {}, %w[OK]] }
    r.get "healthcheck/ready", to: GovukHealthcheck.rack_response
    r.get "*path" => "content_items#show", constraints: { path: %r{.*} }
  end
end
