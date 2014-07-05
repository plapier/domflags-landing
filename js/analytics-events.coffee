$ ->
  window.trackInstall = (str) ->
    ga "send", "event", "Inline install", "Install", str, 1

  trackEvent = (str) ->
    ga "send", "event", "button", "click", str, 1

  trackOutboundLink = (url) ->
    ga "send", "event", "outbound", "click", url,
      hitCallback: ->
        document.location = url

  $(".flags").on "mousedown", "li", (event) ->
    trackEvent "Demo: Panel item"

  $(".dom-tree").on "mousedown", ".tooltip", (event) ->
    trackEvent "Demo: tooltip " + event.target.textContent.toLowerCase()

  $('.marketing-info').on "click", "a", (event) ->
    if event.currentTarget.classList.contains('inbound')
      trackEvent event.currentTarget.id
    else if event.currentTarget.classList.contains('outbound')
      trackOutboundLink(event.currentTarget.href)
      return false
