console.log 'Hello and welcome to One Love DancingFest 👋'

# Variables

## Responsive Breakpoints

smallPhoneMinWidth = 341
phoneMinWidth = 421
tabletMinWidth = 801
desktopMinWidth = 1001
largeDesktopMinWidth = 1441
veryLargeDesktopMinWidth = 1700

## Layout Vars

mainMenu = $('.main-menu')
mainMenuOffsetTop = mainMenu.offset().top
mainMenuHeight = mainMenu.height()
mainMenuHeight = 90
afterMainMenu = $('.main-menu + *')
afterMainMenuOrgPaddingTop = afterMainMenu.css 'padding-top'

# Helpers

this.waitForFinalEvent = (->
  timers = {}
  (callback, ms, uniqueId) ->
    uniqueId = "Don't call this twice without a uniqueId"  unless uniqueId
    clearTimeout timers[uniqueId] if timers[uniqueId]
    timers[uniqueId] = setTimeout(callback, ms)
    return
)()

# Cross-Browser

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

# Layout Functions

refreshViev = () ->
  # CSS3 Fallbacks (Modernizr feature-detects include 在 modernizr.js)
  if not Modernizr.cssvwunit
    $('body').addClass 'no-vw'
    # ...
  # 動態 css
  jsCssNode = document.getElementById('js-css')
  jsCssNode.parentNode.removeChild(jsCssNode) if jsCssNode?.parentNode
  css = '@media screen and (max-width: ' + tabletMinWidth + 'px) { .nav-open nav.main-menu ul { height: ' + ($(window).height() - mainMenuHeight) + 'px; } }'
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
  mainMenu.css 'position', 'relative' if !isIOS and !Modernizr.csssticky
  mainMenuOffsetTop = mainMenu.offset().top
  afterMainMenu = $('.main-menu + *')
  afterMainMenuOrgPaddingTop = afterMainMenu.css 'padding-top'
  $('.wrapper').css 'background-color', $('.main-menu + *').css('background-color')

refreshViev()

onScroll = () ->
  # Sticky Polyfill
  if !isIOS and !Modernizr.csssticky
    scrollTop = $(this).scrollTop()
    # Nav
    if (mainMenuOffsetTop - scrollTop) < 0
      mainMenu.css 'position', 'fixed'
      afterMainMenu.css 'margin-top', mainMenuHeight + 'px'
    else
      mainMenu.css 'position', 'relative'
      afterMainMenu.css 'margin-top', '0'
    # After Nav - BG
    $('.main-menu ~ *').each ->
      if ($(this).offset().top + $(this).height() - mainMenuHeight - scrollTop) < 1
        $(this).children('.a:nth-child(1)').css
          'display': 'block'
          'position': 'absolute'
          'margin-top': '0'
          'top': 'auto'
          'bottom': '0'
      else if ($(this).offset().top - scrollTop) < mainMenuHeight*2
        $(this).children('.a:nth-child(1)').css
          'display': 'block'
          'position': 'fixed'
          'top': '0'
          'bottom': 'auto'
          'margin-top': '0'
      else
        $(this).children('.a:nth-child(1)').css
          'display': 'none'
  # Scroll Reveal
  if !isIOS
    scrollTop = $(this).scrollTop()
    $('*[data-scroll-reveal-threshold]').each ->
      if ($(this).offset().top + $(this).height() + parseInt($(this).attr('data-scroll-reveal-threshold')) - scrollTop - $(window).height()) < 0
        $(this).addClass 'in'
      else
        $(this).removeClass 'in'
  else
    $('*[data-scroll-reveal-threshold]').addClass 'in'

  # Parallax Scrolling
  if $(window).width() >= tabletMinWidth and !isIOS
    scrollTop = $(this).scrollTop()
    $('*[data-background-parallax-rato]').each ->
      if ($(this).offset().top < scrollTop+800 + $(window).height()) and (($(this).offset().top + $(this).height()) > scrollTop-800)
        sStart = $(this).offset().top - $(window).height()
        sEnd = $(this).offset().top + $(this).height()
        pRate = (scrollTop - sStart)/(sEnd - sStart)
        $(this).css 'background-position-y', ((pRate - 0.5)*100*parseFloat($(this).attr('data-background-parallax-rato')) + 50) + '%'
    $('*[data-parallax-rato]').each ->
      if ($(this).offset().top < scrollTop+800 + $(window).height()) and (($(this).offset().top + $(this).height()) > scrollTop-800)
        sStart = $(this).offset().top - $(window).height()
        sEnd = $(this).offset().top + $(this).height()
        pPx = (scrollTop - (sEnd + sStart)/2) * parseFloat($(this).attr('data-parallax-rato'))
        $(this).children('*').css
          'transform': 'translateY(' + pPx + 'px)'
          '-webkit-transform': 'translateY(' + pPx + 'px)'
          '-moz-transform': 'translateY(' + pPx + 'px)'
          '-ms-transform': 'translateY(' + pPx + 'px)'
          '-o-transform': 'translateY(' + pPx + 'px)'


onScroll()

# Bind Events

## Global

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
  $('.main-menu ~ *').each ->
    bgcolor = new RGBColor($(this).css('background-color'))
    $(this).children('.a:nth-child(1)').css
      'display': 'block'
      'height': ((mainMenuHeight)*1) + 'px'
      'margin-top': -((mainMenuHeight)*1) + 'px'
      'width': '100%'
      'top': '0'
      'left': '0'
      'background-color': 'rgba(' + bgcolor.r + ',' + bgcolor.g + ',' + bgcolor.b + ',0.9223)'
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

$(window).scroll ->
  onScroll()
  waitForFinalEvent (->
    refreshViev()
    onScroll()
  ), 1000, "winAfterScr"

# Click

$('.main-menu h1').click ->
  if $(window).width() >= tabletMinWidth
    $("html,body").animate
      scrollTop: 0
    , 1000
  else
    $('.page').toggleClass 'nav-open'
