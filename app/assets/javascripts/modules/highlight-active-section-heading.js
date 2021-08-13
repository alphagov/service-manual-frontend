;(function (Modules, root) {
  'use strict'

  var $ = root.$
  var $window = $(root)

  Modules.HighlightActiveSectionHeading = function () {
    var self = this
    var _hasResized = true
    var _hasScrolled = true
    var _interval = 50
    var anchorIDs = []

    self.getWindowDimensions = function () {
      return {
        height: $window.height(),
        width: $window.width()
      }
    }

    self.getWindowPositions = function () {
      return {
        scrollTop: $window.scrollTop()
      }
    }

    self.getElementOffset = function ($el) {
      return $el.offset()
    }

    self.start = function ($el) {
      $window.resize(self.hasResized)
      $window.scroll(self.hasScrolled)

      setInterval(self.checkResize, _interval)
      setInterval(self.checkScroll, _interval)

      self.$anchors = $el.find('.js-page-contents a')
      self.getAnchors()

      self.checkResize()
      self.checkScroll()
    }

    self.hasResized = function () {
      _hasResized = true
      return _hasResized
    }

    self.hasScrolled = function () {
      _hasScrolled = true
      return _hasScrolled
    }

    self.checkResize = function () {
      if (_hasResized) {
        _hasResized = false
        _hasScrolled = true
      }
    }

    self.checkScroll = function () {
      if (_hasScrolled) {
        _hasScrolled = false
        var windowDimensions = self.getWindowDimensions()
        if (windowDimensions.width <= 768) {
          self.removeActiveItem()
        } else {
          self.updateActiveNavItem()
        }
      }
    }

    self.getAnchors = function () {
      $.each(self.$anchors, function (i) {
        var anchorID = $(this).attr('href')
        // e.g. anchorIDs['#meeting-the-digital-service-standard', '#understand-your-users', '#research-continually']
        anchorIDs.push(anchorID)
      })
    }

    self.getHeadingPosition = function ($theID) {
      return $theID.offset()
    }

    self.getNextHeadingPosition = function ($theNextID) {
      return $theNextID.offset()
    }

    self.getFooterPosition = function ($theID) {
      return $theID.offset()
    }

    self.getDistanceBetweenHeadings = function (headingPosition, nextHeadingPosition) {
      var distanceBetweenHeadings = (nextHeadingPosition - headingPosition)
      return distanceBetweenHeadings
    }

    self.updateActiveNavItem = function () {
      var windowVerticalPosition = self.getWindowPositions().scrollTop
      var footerPosition = self.getFooterPosition($('.govuk-footer'))

      $.each(self.$anchors, function (i) {
        var theID = anchorIDs[i]
        var theNextID = anchorIDs[i + 1]

        var $theID = $(theID)
        var $theNextID = $(theNextID)

        var headingPosition = self.getHeadingPosition($theID)

        if (!headingPosition) {
          return
        }

        headingPosition = headingPosition.top
        headingPosition = headingPosition - 53 // fix the offset from top of page

        if (theNextID) {
          var nextHeadingPosition = self.getNextHeadingPosition($theNextID).top
        }

        var distanceBetweenHeadings = self.getDistanceBetweenHeadings(headingPosition, nextHeadingPosition)
        var isPastHeading

        if (distanceBetweenHeadings) {
          isPastHeading = (windowVerticalPosition >= headingPosition && windowVerticalPosition < (headingPosition + distanceBetweenHeadings))
        } else {
          // when distanceBetweenHeadings is false (as there isn't a next heading)
          isPastHeading = (windowVerticalPosition >= headingPosition && windowVerticalPosition < footerPosition.top)
        }

        if (isPastHeading) {
          self.setActiveItem(theID)
        }
      })
    }

    self.setActiveItem = function (theID) {
      self.$anchors.removeClass('active')
      self.$anchors.filter("[href='" + theID + "']").addClass('active')
    }

    self.removeActiveItem = function () {
      self.$anchors.removeClass('active')
    }
  }
})(window.GOVUK.Modules, window)
