$(document).ready ->
  $domflagsPanel = $('.domflags-panel')
  $domtree = $('.dom-tree')
  $treeDomflags = $domtree.find('span').filter( ->
    $(@).text() is "domflag"
  )

  $treeDomflags.addClass('domflag-attr').parent().addClass('domflag-line')

  $domflagsPanel.on('click', 'li', ->
    index = $domflagsPanel.find('li').index(@)
    $el = $treeDomflags.eq(index)

    $domflagsPanel.find('li').removeClass('active')
    $(@).addClass('active')
    $domtree.find('span').removeClass('selected')
    $el.parent().addClass('selected')

    ## Scroll to line if el is offscreen
    $elPos = $el.offset().top
    $domtreeTop = $domtree.offset().top
    $domtreeBottom = $domtreeTop + $domtree.height()
    unless $elPos > $domtreeTop and $elPos < $domtreeBottom
      $domtree.scrollTo('.domflag-line.selected')
  )
  $('#start-demo').on('click', ->
    $('.devtools-toolbar').addClass('open')
    $('.devtools').addClass('open')
    $domflagsPanel.addClass('open')
    return false
  )

  ## NEEDS REFACTORING
  $('.dom-tree code > span').addClass('tooltip')

  $('.tooltip').tooltipster({
    content: '<a href="#">Add Domflag</a>'
    contentAsHTML: true
    position: 'left'
    interactive: true
    speed: 300
    animation: 'fade'
    onlyOne: true
    delay: 400
    # functionReady: (origin) ->
      # $('.dom-tree code > span').hover( ->
        # setTimeout =>
          # $lastSpan = $(@).find('span:last-of-type')
          # posX = $lastSpan.offset().left + $lastSpan.width() + 25
          # console.log posX
          # $('.tooltipster-base').css 'left', posX + "px"
        # , 400
      # )
  })

