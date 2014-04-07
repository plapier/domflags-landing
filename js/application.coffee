$(document).ready ->
  $domflagsPanel = $('.domflags-panel')
  $domtree = $('.dom-tree')
  $treeDomflags = $domtree.find('span').filter( ->
    $('#line-2').addClass('non-flaggable')
    if $(@).hasClass('s')
      $(@).parent().addClass('flaggable')
    $(@).text() is "domflag"
  )

  $treeDomflags.addClass('domflag-attr').parent().addClass('domflag-line')

  $domflagsPanel.on('click', 'li', ->
    index = $domflagsPanel.find('li').index(@)
    $el = $domtree.find('.domflag-line').eq(index)

    $domflagsPanel.find('li').removeClass('active')
    $(@).addClass('active')
    $domtree.find('span').removeClass('selected')
    $el.addClass('selected')

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
    $domflagStr = '<span class="na domflag-attr">domflag</span>'
    $parent = $(@).parent()

    if $parent.hasClass('domflag-line')
      index = $parent.index('.domflag-line')
      $domflagsPanel.find('li').eq(index).remove()
      $parent.removeClass('domflag-line').find('.domflag-attr').remove()
    else
      elString = []
      stringArray = $(@).siblings().contents().filter( (index) ->
        unless @data.match(/\>/g) ## unless closing tag
          string = @data
          string = @data.toUpperCase() + " " if index == 0
          elString.push string.replace(/</g,' ').replace(/\= /, '=') ## formatting cleanup
      )
      $parent.addClass('domflag-line').find('.s').after($domflagStr)
      index = $parent.index('.domflag-line')
      flagItem = "<li class='flag'>#{elString.join("")}</li>"

      if index < $('ol.flags li').length
        $('ol.flags li').eq(index).before(flagItem)
      else
        $('ol.flags').append(flagItem)
  )
