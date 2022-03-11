/* eslint-disable no-multi-str */

describe('A highlight active section heading module', function () {
  'use strict'

  var module
  var $element

  beforeEach(function () {
    $element = $(
      '<div>\
        <div class="govuk-grid-row" data-module="highlight-active-section-heading">\
          <div class="govuk-grid-column-one-third">\
            <div class="page-contents js-page-contents js-stick-at-top-when-scrolling">\
              <h2 class="page-contents__title">Page contents:</h2>\
              <ul class="page-contents__list">\
                <li><a href="#section-1">Section 1</a></li>\
                <li><a href="#section-2">Section 2</a></li>\
                <li><a href="#section-3">Section 3</a></li>\
              </ul>\
            </div>\
          </div>\
          <div class="govuk-grid-column-two-thirds">\
            <div class="govspeak-wrapper">\
              <div class="govuk-govspeak">\
                <h2 id="section-1">Section 1</h2>\
                <p>Section 1 text</p>\
                <h2 id="section-2">Section 2</h2>\
                <p>Section 2 text</p>\
                <h2 id="section-3">Section 3</h2>\
                <p>Section 3 text</p>\
              </div>\
            </div>\
          </div>\
        </div>\
        <div class="govuk-footer"></div>\
      </div>'
    )
    module = new GOVUK.Modules.HighlightActiveSectionHeading($element[0])

    module.getWindowDimensions = function () {
      return {
        height: 768,
        width: 1024
      }
    }
    module.getFooterPosition = function () {
      return 500
    }
    module.getHeadingPosition = function () {
      return 100
    }
    module.getNextHeadingPosition = function () {
      return 200
    }
  })

  afterEach(function () {
    $(document).off()
  })

  // The anchor link with the href matching testHref should be highlighted
  function isLinkHighlighted (testHref) {
    var $anchor = $element.find('.js-page-contents a[href="' + testHref + '"]')
    expect($anchor.hasClass('active')).toBe(true)
  }

  it('When the page loads, it has no highlighted nav items', function () {
    module.getWindowPositions = function () {
      return 0
    }
    module.init()

    var $anchors = $element.find('.js-page-contents a')
    expect($anchors.hasClass('active')).toBe(false)
  })

  it('When the page is scrolled, it highlights a nav item', function () {
    module.getWindowPositions = function () {
      return 180
    }
    module.init()

    isLinkHighlighted('#section-3')
  })
})
