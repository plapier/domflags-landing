$(document).ready ->
  $domflagsPanel = $('.domflags-panel')
  $tree = $('.dom-tree span')
  $treeDomflags = $tree.filter( ->
    $(@).text() is "domflag"
  )

  $treeDomflags.addClass('domflag-attr').parent().addClass('domflag-line')

  $domflagsPanel.on('click', 'li', ->
    index = $domflagsPanel.find('li').index(@)
    $tree.removeClass('selected')
    $treeDomflags.eq(index).parent().addClass('selected')
  )
