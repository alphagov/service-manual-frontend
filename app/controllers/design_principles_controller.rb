class DesignPrinciplesController < ApplicationController
  include Slimmer::Headers
  include Slimmer::Template
  rescue_from GdsApi::HTTPForbidden, with: :error_403

  def designprinciples
  end

  def performanceframework
  end

  def accessiblepdfs
    render "accessible-pdfs"
  end
end
