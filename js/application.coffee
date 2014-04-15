$(document).ready ->
  new SetupDemo()

class SetupDemo
  constructor: ->
    @panel = $('.domflags-panel')
    @tree  = $('.dom-tree')
    @treeLines = @tree.find('code > span')
    @treeFlags = @getTreeFlags()
    @folds = [
      { start: 7, end: 11 }
      { start: 4, end: 28 }
    ]
    @setupTree()
    @foldingEvents()
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
    @treeLines.find('span:last-of-type').after(tooltipStr).end().filter('.domflag-line').find('.tooltip').text('Remove Domflag')
    $('#line-2').addClass('non-flaggable')

    @foldBlock(@folds) ## Fold all blocks

  foldingEvents: ->
    $('.fold-true').on 'click', (event) =>
      $parent = $(event.currentTarget).parent()
      if $parent.hasClass('fold-block')
        @unfoldBlock(event.currentTarget)
      else
        spanID = parseInt $(event.currentTarget)[0].id.replace(/\D/g,'') ## Get line-id
        foldObject = $.grep(@folds, (obj) ->
          obj.start is spanID
        )
        @foldBlock(foldObject)

  unfoldBlock: (target) ->
    $(target).removeClass('fold-parent').attr('style', '').siblings().removeClass('fold-parent fold-inner').unwrap()

  foldBlock: (folds) ->
    for fold in folds
      $start = @tree.find("#line-#{fold.start}")
      $end   = @tree.find("#line-#{fold.end}")
      $inner = @tree.find($start).nextUntil($end)
      $block = @tree.find("#line-#{fold.start - 1}").nextUntil("#line-#{fold.end + 1}")
      # console.log $start.find('span:first-of-type').offset().left
      $paddingLeft = $start.find('span:first-of-type').offset().left - @tree.offset().left
      $start.addClass('fold-true fold-parent').css('padding-left', "#{$paddingLeft}px")
      $end.addClass('fold-parent')
      $inner.addClass('fold-inner')
      $block.wrapAll('<div class="fold-block" />')

  demoEvents: ->
    ## Add parent OPEN class and refactor
    $('#start-demo').on('click', (event) =>
      $(event.currentTarget).addClass('hide').parent().addClass('show-download')
      $('.devtools-toolbar, .devtools').addClass('open')
      @panel.addClass('open').find('li:first-child').addClass('demo')
      return false
    )

  panelEvents: ->
    $('.devtools').on "transitionend webkitTransitionEnd", ->
      $('.browser').addClass('open')
      $('#start-demo').addClass('hide')
      $('#download').addClass('show')

    @panel.on('click', 'li', (event) =>
      index = @panel.find('li').index(event.currentTarget)
      $el = @tree.find('.domflag-line').eq(index)
      $target = $('.target')

      if $(event.currentTarget).hasClass('demo') and index < 2
        $target.addClass("pos-#{index + 1}")
        $(event.currentTarget).next().addClass('demo')
      else
        $target.hide()

      @panel.find('li').removeClass('active').end().find(event.currentTarget).addClass('active').removeClass('demo new')
      @tree.find('span').removeClass('selected')
      $el.addClass('selected')

      ## Scroll to line if el is offscreen
      ## TODO: unfold parent blocks when hidden
      # if $el.is(':hidden')
        # $el.parent.attr('style', '').siblings().removeClass('fold-parent fold-inner').unwrap()

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
        index = $parent.index('.domflag-line')
        $(event.currentTarget).text('Add Domflag')
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
