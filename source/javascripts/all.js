//= require jquery/dist/jquery.js
//= require fastclick/lib/fastclick.js
//= require foundation/js/foundation.js
//= require baseline.js
//= require jquery.lazyload/jquery.lazyload
//= include app.js

// foundation

$(document).foundation();

// FastClick

window.addEventListener('load', function() {
    FastClick.attach(document.body);
}, false);
