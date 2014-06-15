//= require jquery/dist/jquery.js
//= require fastclick/lib/fastclick.js
//= require foundation/js/foundation.js
//= require smoothScrolling.js
//= require rgbcolor.js
//= require jquery.lazyload/jquery.lazyload
//= require parallax/deploy/parallax.js
//= require scrollReveal.js/dist/scrollReveal.js
//= include app.js

// foundation

$(document).foundation();

// FastClick

window.addEventListener('load', function() {
    FastClick.attach(document.body);
}, false);

var scrollRevealConfig = {
  after: '0s',
  enter: 'bottom',
  move: '24px',
  over: '0.66s',
  easing: 'ease-in-out',
  viewportFactor: 0.33,
  reset: true,
  init: true
};

window.scrollReveal = new scrollReveal(scrollRevealConfig);
