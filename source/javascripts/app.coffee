console.log 'Hello and welcome to One Love DancingFest 👋'

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
  css = ""
  head = document.head or document.getElementsByTagName("head")[0]
  style = document.createElement("style")
  style.type = "text/css"
  style.id = "js-css"
  if style.styleSheet
    style.styleSheet.cssText = css
  else
    style.appendChild document.createTextNode(css)
  head.appendChild style

refreshViev()

# 按鈕動作
# ...

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

# on load !
$(window).load ->
  refreshViev()

$(window).resize ->
  waitForFinalEvent (->
    refreshViev()
  ), 500, "winRz"
