$ ->
  trackEvent = (str) ->
    ga "send", "event", "button", "click", str, 1

  trackOutboundLink = (url) ->
    ga "send", "event", "outbound", "click", url,
      hitCallback: ->
        document.location = url

  $(".flags").on "click", "li", (event) ->
    trackEvent "Demo: Panel item"

  $(".dom-tree").on "click", ".tooltip", (event) ->
    trackEvent "Demo: tooltip " + event.target.textContent.toLowerCase()

  $('.marketing-info').on "click", "a", (event) ->
    if event.target.id is "install-button"
      trackEvent "Marketing: Inline Install"
    else
      trackOutboundLink(event.target.href)
    return false
