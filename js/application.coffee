$(document).ready ->
  $panel = $('.domflags-panel')
  $tree = $('.dom-tree')
  $treeFlags = $tree.find('span').filter( ->
    if $(@).hasClass('s')
      $(@).parent().addClass('flaggable')
    $(@).text() is "domflag"
  )

  $treeFlags.addClass('domflag-attr').parent().addClass('domflag-line')

  $panel.on('click', 'li', ->
    if $(@).eq(0).hasClass('demo')
      $('a.target').addClass('second')
    else
      $('a.target').hide()

    index = $panel.find('li').index(@)
    $el = $tree.find('.domflag-line').eq(index)

    $panel.find('li').removeClass('active')
    $(@).addClass('active').removeClass('demo new')
    $tree.find('span').removeClass('selected')
    $el.addClass('selected')

    ## Scroll to line if el is offscreen
    $elPos = $el.offset().top
    $treeTop = $tree.offset().top
    $treeBottom = $treeTop + $tree.height()
    unless $elPos > $treeTop and $elPos < $treeBottom
      $tree.scrollTo('.domflag-line.selected')
  )
  $('#start-demo').on('click', ->
    $(@).addClass('hide')
    $('.devtools-toolbar').addClass('open')
    $('.devtools').addClass('open')
    $panel.addClass('open')
    $panel.find('li:first-child').addClass('demo')
    return false
  )

  ## NEEDS REFACTORING
  $('.dom-tree code > span').find('span:last-of-type').after('<span class="tooltip">Add Domflag</span>')
  $('#line-2').addClass('non-flaggable')
  $('.domflag-line').find('.tooltip').text('Remove Domflag')

  $('.tooltip').on('click', ->
    $domflagStr = '<span class="na domflag-attr">domflag</span>'
    $parent = $(@).parent()

    if $parent.hasClass('domflag-line')
      $(@).text('Add Domflag')
      index = $parent.index('.domflag-line')
      $panel.find('li').eq(index).remove()
      $parent.removeClass('domflag-line').find('.domflag-attr').remove()
    else
      $(@).text('Remove Domflag')
      elString = []
      stringArray = $(@).siblings().contents().filter( (index) ->
        unless @data.match(/\>/g) ## unless closing tag
          string = @data
          string = @data.toUpperCase() + " " if index == 0
          elString.push string.replace(/</g,' ').replace(/\= /, '=') ## formatting cleanup
      )
      $parent.addClass('domflag-line').find('.s').after($domflagStr)
      index = $parent.index('.domflag-line')
      flagItem = "<li class='flag new'>#{elString.join("")}</li>"

      if index < $('ol.flags li').length
        $('ol.flags li').eq(index).before(flagItem)
      else
        $('ol.flags').append(flagItem)
  )
