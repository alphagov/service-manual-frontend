// from govuk_frontend_toolkit
//= require stick-at-top-when-scrolling
//= require govuk/stop-scrolling-at-footer
//= require_tree .

window.GOVUK.stickAtTopWhenScrolling.init();
window.GOVUK.stopScrollingAtFooter.addEl($('.page-contents'));
