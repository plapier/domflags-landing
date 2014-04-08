$(document).ready ->
  new SetupDemo()

class SetupDemo
  constructor: ->
    @panel = $('.domflags-panel')
    @tree  = $('.dom-tree')
    @treeLines = @tree.find('code > span')
    @treeFlags = @getTreeFlags()
    @setupTree()
    @demoEvents()
    @panelEvents()
    @tooltipEvents()

  getTreeFlags: ->
    @tree.find('span').filter( ->
      if $(@).hasClass('s')
        $(@).parent().addClass('flaggable')
      $(@).text() is "domflag"
    )

  setupTree: ->
    tooltipStr= '<span class="tooltip">Add Domflag</span>'
    @treeFlags.addClass('domflag-attr').parent().addClass('domflag-line')
    @treeLines.find('span:last-of-type').after(tooltipStr).end().find('.domflag-line .tooltip').text('Remove Domflag')
    $('#line-2').addClass('non-flaggable')

  demoEvents: ->
    ## Add parent OPEN class and refactor
    $('#start-demo').on('click', (event) =>
      $(event.currentTarget).addClass('hide')
      $('.devtools-toolbar').addClass('open')
      $('.devtools').addClass('open')
      @panel.addClass('open')
      @panel.find('li:first-child').addClass('demo')
      return false
    )

  panelEvents: ->
    @panel.on('click', 'li', (event) =>
      if $(event.currentTarget).eq(0).hasClass('demo')
        $('a.target').addClass('second')
      else
        $('a.target').hide()

      index = @panel.find('li').index(event.currentTarget)
      $el = @tree.find('.domflag-line').eq(index)

      @panel.find('li').removeClass('active')
      $(event.currentTarget).addClass('active').removeClass('demo new')
      @tree.find('span').removeClass('selected')
      $el.addClass('selected')

      ## Scroll to line if el is offscreen
      $elPos = $el.offset().top
      @treeTop = @tree.offset().top
      @treeBottom = @treeTop + @tree.height()
      unless $elPos > @treeTop and $elPos < @treeBottom
        @tree.scrollTo('.domflag-line.selected')
    )

  tooltipEvents: ->
    $('.tooltip').on('click', (event) =>
      $domflagStr = '<span class="na domflag-attr">domflag</span>'
      $parent = $(event.currentTarget).parent()

      if $parent.hasClass('domflag-line')
        $(event.currentTarget).text('Add Domflag')
        index = $parent.index('.domflag-line')
        $(@panel).find('li').eq(index).remove()
        $parent.removeClass('domflag-line').find('.domflag-attr').remove()
      else
        $(event.currentTarget).text('Remove Domflag')
        elString = []
        stringArray = $(event.currentTarget).siblings().contents().filter( (index) ->
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
