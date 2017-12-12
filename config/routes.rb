Rails.application.routes.draw do
  mount JasmineRails::Engine => '/specs' if defined?(JasmineRails)

  get '/service-manual/search', to: redirect { |_, request|
    query = request.query_parameters.merge(filter_manual: '/service-manual').to_query
    "/search?#{query}"
  }

  get "/design-principles", :to => "design_principles#designprinciples"
  get "/design-principles/performanceframework", :to => "design_principles#performanceframework"
  get "/design-principles/accessiblepdfs", :to => "design_principles#accessiblepdfs"

  with_options format: false do |r|
    r.get 'healthcheck', to: proc { [200, {}, ['']] }
    r.get '*path' => 'content_items#show', constraints: { path: %r[.*] }
  end
end
