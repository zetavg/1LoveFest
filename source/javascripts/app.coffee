console.log 'Hello and welcome to One Love DancingFest 👋'

# ----- Responsive Breakpoints ----- #

smallPhoneMinWidth = 341
phoneMinWidth = 421
tabletMinWidth = 801
desktopMinWidth = 1001
largeDesktopMinWidth = 1441
veryLargeDesktopMinWidth = 1700

this.waitForFinalEvent = (->
  timers = {}
  (callback, ms, uniqueId) ->
    uniqueId = "Don't call this twice without a uniqueId"  unless uniqueId
    clearTimeout timers[uniqueId] if timers[uniqueId]
    timers[uniqueId] = setTimeout(callback, ms)
    return
)()

refreshViev = () ->
  # CSS3 Fallbacks (Modernizr feature-detects include 在 modernizr.js)
  if not Modernizr.cssvwunit
    $('body').addClass 'no-vw'
    # ...
  # 動態 css
  jsCssNode = document.getElementById('js-css')
  jsCssNode.parentNode.removeChild(jsCssNode) if jsCssNode?.parentNode
  css = '@media screen and (max-width: ' + tabletMinWidth + 'px) { .nav-open nav.main-menu ul { height: ' + ($(window).height() - $('.main-menu').height()) + 'px; } }'
  # css += '@media screen and (max-width: ' + tabletMinWidth + 'px) { .main-menu.open { margin-bottom: -' + ($('.main-menu ul li').length*50 + 18) + 'px; } }'
  # css += '@media screen and (max-width: ' + tabletMinWidth + 'px) { .main-menu.open ~ * .a:nth-child(1) { height: ' + ($('.main-menu ul li').length*50 + 18)*1.26 + 'px !important; margin-top: -' + ($('.main-menu ul li').length*50 + 18)*1.26 + 'px !important; } }'
  head = document.head or document.getElementsByTagName("head")[0]
  style = document.createElement("style")
  style.type = "text/css"
  style.id = "js-css"
  if style.styleSheet
    style.styleSheet.cssText = css
  else
    style.appendChild document.createTextNode(css)
  head.appendChild style

  # Nav
  mainMenu = $('.main-menu')
  mainMenuOffsetTop = mainMenu.offset().top
  afterMainMenu = $('.main-menu + *')
  afterMainMenuOrgPaddingTop = afterMainMenu.css 'padding-top'
  $('.wrapper').css 'background-color', $('.main-menu + *').css('background-color')
  # Nav BG Effect
  $('.main-menu ~ *').each ->
    bgcolor = new RGBColor($(this).css('background-color'))
    $(this).children('.a:nth-child(1)').css
      'display': 'block'
      'height': mainMenu.height()*1.26 + 'px'
      'margin-top': -mainMenu.height()*1.26 + 'px'
      'width': '100%'
      'top': '0'
      'left': '0'
      'background': '-moz-linear-gradient(top, rgba(' + bgcolor.r + ',' + bgcolor.g + ',' + bgcolor.b + ',0.9223) 0%, rgba(' + bgcolor.r + ',' + bgcolor.g + ',' + bgcolor.b + ',0.9223) 80%, rgba(' + bgcolor.r + ',' + bgcolor.g + ',' + bgcolor.b + ',0) 92%)'
      'background': '-webkit-gradient(linear, left top, left bottom, color-stop(0%,rgba(' + bgcolor.r + ',' + bgcolor.g + ',' + bgcolor.b + ',0.9223)), color-stop(80%,rgba(' + bgcolor.r + ',' + bgcolor.g + ',' + bgcolor.b + ',0.9223)), color-stop(92%,rgba(' + bgcolor.r + ',' + bgcolor.g + ',' + bgcolor.b + ',0)))'
      'background': '-webkit-linear-gradient(top, rgba(' + bgcolor.r + ',' + bgcolor.g + ',' + bgcolor.b + ',0.9223) 0%,rgba(' + bgcolor.r + ',' + bgcolor.g + ',' + bgcolor.b + ',0.9223) 80%,rgba(' + bgcolor.r + ',' + bgcolor.g + ',' + bgcolor.b + ',0) 92%)';
      'background': '-o-linear-gradient(top, rgba(' + bgcolor.r + ',' + bgcolor.g + ',' + bgcolor.b + ',0.9223) 0%,rgba(' + bgcolor.r + ',' + bgcolor.g + ',' + bgcolor.b + ',0.9223) 80%,rgba(' + bgcolor.r + ',' + bgcolor.g + ',' + bgcolor.b + ',0) 92%)';
      'background': '-ms-linear-gradient(top, rgba(' + bgcolor.r + ',' + bgcolor.g + ',' + bgcolor.b + ',0.9223) 0%,rgba(' + bgcolor.r + ',' + bgcolor.g + ',' + bgcolor.b + ',0.9223) 80%,rgba(' + bgcolor.r + ',' + bgcolor.g + ',' + bgcolor.b + ',0) 92%)';
      'background': 'linear-gradient(to bottom, rgba(' + bgcolor.r + ',' + bgcolor.g + ',' + bgcolor.b + ',0.9223) 0%,rgba(' + bgcolor.r + ',' + bgcolor.g + ',' + bgcolor.b + ',0.9223) 80%,rgba(' + bgcolor.r + ',' + bgcolor.g + ',' + bgcolor.b + ',0) 92%)';

  # Sticky Polyfill
  i = 0
  $('.main-menu ~ *').each ->

  $(window).scroll ->
    # Sticky Polyfill
    if !isIOS and !Modernizr.csssticky
      scrollTop = $(this).scrollTop()
      # Nav
      if (mainMenuOffsetTop - scrollTop) < 0
        mainMenu.css 'position', 'fixed'
        # afterMainMenu.css 'padding-top', (afterMainMenuOrgPaddingTop+mainMenu.height) + 'px'
        afterMainMenu.css 'margin-top', mainMenu.height() + 'px'
      else
        mainMenu.css 'position', 'relative'
        # afterMainMenu.css 'padding-top', (afterMainMenuOrgPaddingTop) + 'px'
        afterMainMenu.css 'margin-top', '0'
      # After Nav - BG
      # if $(window).width() > tabletMinWidth
      $('.main-menu ~ *').each ->
        if ($(this).offset().top + $(this).height() - mainMenu.height() - scrollTop) < 12
          $(this).children('.a:nth-child(1)').css
            'display': 'block'
            'position': 'absolute'
            'margin-top': '0'
            'top': 'auto'
            'bottom': '0'
        else if ($(this).offset().top - scrollTop) < mainMenu.height()*2
          $(this).children('.a:nth-child(1)').css
            'display': 'block'
            'position': 'fixed'
            'top': '0'
            'bottom': 'auto'
            'margin-top': '0'
        else
          $(this).children('.a:nth-child(1)').css
            'display': 'none'
      # else
      #   $('.main-menu ~ *').children('.a:nth-child(1)').css 'display', 'none'

refreshViev()

# 按鈕動作
$('.main-menu h1').click ->
  if $(window).width() >= tabletMinWidth
    $("html,body").animate
      scrollTop: 0
    , 1000
  else
    $('.page').toggleClass 'nav-open'

# 針對不同瀏覽器及系統的處理
if window.chrome
  isChrome = true
  $('body').addClass 'chrome'
if Modernizr.touch
  isTouch = true
  $('body').addClass 'touch'
else
  $('body').addClass 'non-touch'
if navigator.platform.toUpperCase().indexOf('MAC')>=0
  isMac = true
  $('body').addClass 'mac'
if navigator.platform.match(/(iPhone|iPod|iPad)/i)
  isIOS = true
  $('body').addClass 'ios'
if navigator.appVersion.match(/(Win)/i)
  isWin = true
  $('body').addClass 'windows'

$(document).ready ->
  # lazyload all images
  llThreshold = (if isIOS then 5000 else 0)
  $(".lazyload").show()
  $("img").lazyload
    effect: "fadeIn"
    threshold: llThreshold
    failure_limit: 10
  # Nav BG Effect
  $('.main-menu ~ *').prepend '<div class="a"></div>'
  refreshViev()
  setTimeout refreshViev(), 300
  setTimeout refreshViev(), 1000
  setTimeout refreshViev(), 5000

# on load !
$(window).load ->
  refreshViev()
  setTimeout refreshViev(), 300
  setTimeout refreshViev(), 1000
  setTimeout refreshViev(), 5000

$(window).resize ->
  $('.main-menu').removeClass 'open'
  waitForFinalEvent (->
    refreshViev()
  ), 10, "winRz"
