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
  $('.dom-tree code > span').find('span:last-of-type').after('<span class="tooltip">Add Domflag</span>')

  $('.tooltip').on('click', ->
    $domflagStr = ' <span class="na domflag-attr">domflag</span>'

    $(@).parent().addClass('.domflag-line').find('span.s').after($domflagStr)
  )

