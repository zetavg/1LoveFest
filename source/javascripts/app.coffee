console.log 'Hello and welcome to One Love DancingFest 👋'

# Variables

## Responsive Breakpoints

smallPhoneMinWidth = 341
phoneMinWidth = 421
tabletMinWidth = 861
desktopMinWidth = 1025
largeDesktopMinWidth = 1441
veryLargeDesktopMinWidth = 1700

## Layout Vars

mainMenu = $('.main-menu')
mainMenuOffsetTop = mainMenu.offset().top
mainMenuHeight = mainMenu.height()
mainMenuHeight = 90
afterMainMenu = $('.main-menu + *')
afterMainMenuOrgPaddingTop = afterMainMenu.css 'padding-top'
toc = $('main .toc ul')
tocli = $('main .toc li')
tocHeight = 0
tocOffsetTop = 360
main = $('main')
mainHeight = 0
mainOffsetTop = 330
indexTitle = $('.welcome .title')
headerTitle = $('header .title')
headerOneLove = $('header .onelove')

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
if Modernizr.csssticky
  $('body').addClass 'csssticky'

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
  css += 'main .inner .toc, main .inner .content::before { height: ' + $('main .inner').height() + 'px; }'
  css += 'main .inner .toc li::before { width: ' + $('main').width() + 'px; left: -' + $('main .inner .toc li').offset()?.left + 'px; }'
  # css += '@media screen and (max-width: ' + tabletMinWidth + 'px) { .main-menu.open { margin-bottom: -' + ($('.main-menu ul li').length*50 + 18) + 'px; } }'
  # css += '@media screen and (max-width: ' + tabletMinWidth + 'px) { .main-menu.open ~ * .a:nth-child(1) { height: ' + ($('.main-menu ul li').length*50 + 18)*1.26 + 'px !important; margin-top: -' + ($('.main-menu ul li').length*50 + 18)*1.26 + 'px !important; } }'
  # Nav 分散對齊
  i = 92 # icon
  $('nav.main-menu ul').children().each ->
    i += $(this).width()
  m = ($('nav.main-menu ul').width() - i)/$('nav.main-menu ul').children().length - 1
  m = 50 if m > 50
  css += '@media screen and (min-width: ' + tabletMinWidth + 'px) { nav.main-menu ul li { margin-left: ' + m + 'px; } }'
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
  # toc
  main = $('main')
  toc = $('main .toc ul')
  if toc.length
    mainHeight = main.height()
    # mainOffsetTop = main.offset().top
    toc.css 'position', 'relative' if !isIOS and !Modernizr.csssticky
    tocHeight = toc.height()
    # tocOffsetTop = toc.offset().top
  # $('.wrapper').css 'background-color', $('.main-menu + *').css('background-color')

  $('.ticket--pull').each ->
    if $(window).width() >= tabletMinWidth
      $(this).css
        'top': ($(this).next().height() - $(this).height())/2 + 'px'
      $(this).next().css
        'top': '0'
    else
      $(this).css
        'top': ($(this).next().height() + 48) + 'px'
      $(this).next().css
        'top': (- $(this).height() - 60) + 'px'

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
    # toc
    if toc.length
      if scrollTop > mainOffsetTop + mainHeight - mainMenuHeight - tocHeight - 30
        toc.css
          'position': 'absolute'
          'top': 'auto'
          'bottom': '0'
      else if (tocOffsetTop - scrollTop - mainMenuHeight) < 0
        toc.css
          'position': 'fixed'
          'top': (mainMenuHeight + 'px')
          'bottom': 'auto'
      else
        toc.css
          'position': 'relative'
          'top': '0'
          'bottom': 'auto'
    tocli.removeClass 'active'
    tocli.each ->
      if $($(this).children('a').attr('href')).offset()?.top < scrollTop + 200
        tocli.removeClass 'active'
        $(this).addClass 'active'

    if indexTitle.length and !isIOS and $(window).width() >= tabletMinWidth
      indexTitle.css
        'margin-top': (scrollTop/2) + 'px'
        'margin-bottom': -(scrollTop/2) + 'px'
    if headerTitle.length and !isIOS and $(window).width() >= tabletMinWidth
      headerTitle.css
        'margin-top': (scrollTop/1.8) + 'px'
        'margin-bottom': -(scrollTop/1.8) + 'px'
    if headerOneLove.length and !isIOS and $(window).width() >= tabletMinWidth
      headerOneLove.css
        'margin-top': (scrollTop/4) + 'px'
        'margin-bottom': -(scrollTop/4) + 'px'

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

  # # Parallax Scrolling
  # if $(window).width() >= tabletMinWidth and !isIOS
  #   scrollTop = $(this).scrollTop()
  #   winHeight = $(window).height()
  #   $('*[data-background-parallax-rato]').each ->
  #     if ($(this).offset().top < scrollTop+80 + winHeight) and (($(this).offset().top + $(this).height()) > scrollTop-80)
  #       sStart = $(this).offset().top - winHeight
  #       px = scrollTop - sStart
  #       $(this).css 'background-position-y', -(px*parseFloat($(this).attr('data-background-parallax-rato'))) + 'px'
  #   $('*[data-parallax-rato]').each ->
  #     container = $(this).parent()
  #     cot = container.offset().top
  #     ch = container.height()
  #     if (cot < scrollTop+800 + winHeight) and ((cot + ch) > scrollTop-800)
  #       sStart = cot - winHeight
  #       sEnd = cot + ch
  #       pPx = (scrollTop - (sEnd + sStart)/2) * parseFloat($(this).attr('data-parallax-rato'))
  #       # $(this).css
  #       #   'top': pPx + 'px'

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
    if $(this).scrollTop() < $('.main-menu').offset().top
      $("html,body").animate
        scrollTop: $('.main-menu').offset().top
      , 500
    $('.page').toggleClass 'nav-open'
