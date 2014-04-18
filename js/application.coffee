$(document).ready ->
  new SetupDemo()

class SetupDemo
  constructor: ->
    @panel = $('.domflags-panel')
    @tree  = $('.dom-tree')
    @treeFlags = @getTreeFlags()
    @tooltipStr = '<span class="tooltip">Add Domflag</span>'
    @folds = [
      { start: 30, end: 35 }
      { start: 26, end: 36 }
      { start: 25, end: 38 }
      { start: 18, end: 21 }
      { start: 15, end: 22 }
      { start: 14, end: 23 }
      { start: 8, end: 12 }
      { start: 7, end: 39 }
      { start: 6, end: 40 }
      { start: 4, end: 41 }
    ]
    @demoEvents()


  getTreeFlags: ->
    @tree.find('span').filter ->
      if $(@).hasClass('s')
        $(@).parent().addClass('flaggable')
      $(@).text() is "domflag"

  initTree: ->
    @setupTreeNodes()
    @foldBlocks(@folds)
    @foldingEvents()
    @panelEvents()
    @tooltipEvents()

  setupTreeNodes: ->
    @treeFlags.addClass('domflag-attr').parent().addClass('domflag-line')

    $treeLines = @tree.find('code > span')
    $treeLines.find('span:last-of-type').after(@tooltipStr).end()
      .filter('.domflag-line').find('.tooltip').text('Remove Domflag')
    $('#line-2').addClass('non-flaggable')


  foldingEvents: ->
    $('.fold-true').on 'click', 'a', (event) =>
      $parent = $(event.delegateTarget).parent()
      if $parent.hasClass('fold-block')
        @unfoldBlock(event.delegateTarget)
      else
        spanID = parseInt $(event.delegateTarget)[0].id.replace(/\D/g,'') ## Get line-id
        foldObject = $.grep @folds, (obj) ->
          obj.start is spanID
        @foldBlocks(foldObject)

  unfoldBlock: (target) ->
    leftVal = parseInt $(target).parent().css('padding-left')
    $(target).removeClass('fold-parent').attr('style', '')
      .siblings().removeClass('fold-parent fold-inner').unwrap()
    $(target).children('a').addClass('open')

  foldBlocks: (folds) ->
    for fold in folds
      $start = @tree.find("#line-#{fold.start}")
      $end   = @tree.find("#line-#{fold.end}")
      $inner = @tree.find($start).nextUntil($end)
      $block = @tree.find("#line-#{fold.start - 1}").nextUntil("#line-#{fold.end + 1}")
      $paddingLeft = Math.ceil $start.find('span:first-of-type').offset().left - @tree.offset().left
      $start.addClass('fold-true fold-parent').children('a').css('left', "#{$paddingLeft}px").removeClass('open')
      $end.addClass('fold-parent')
      $inner.addClass('fold-inner')
      blockStr = "<div class='fold-block' style='padding-left: #{$paddingLeft}px' />"
      $block.wrapAll(blockStr)

  demoEvents: ->
    ## Add parent OPEN class and refactor
    $('#start-demo').on 'click', (event) =>
      $(event.currentTarget).addClass('hide').parent().addClass('show-download')
      $('.devtools-toolbar, .devtools').addClass('open')
      @panel.addClass('open').find('li:first-child').addClass('demo')

      @initTree() ## initTree after click to fix arrow position bug
      return false

  panelEvents: ->
    $('.devtools').on "transitionend webkitTransitionEnd", ->
      $('.browser').addClass('open')
      $('#start-demo').addClass('hide')
      $('#download').addClass('show')

    @panel.on 'click', 'li', (event) =>
      index = @panel.find('li').index(event.currentTarget)
      $el = @tree.find('.domflag-line').eq(index)
      $target = $('.target')

      if $(event.currentTarget).hasClass('demo') and index < 2
        $target.addClass("pos-#{index + 1}")
        $(event.currentTarget).next().addClass('demo')
      else
        $target.hide()

      @panel.find('li').removeClass('active').end()
        .find(event.currentTarget).addClass('active').removeClass('demo new')
      @tree.find('span').removeClass('selected')
      $el.addClass('selected')

      ## Unfold blocks if selected node is hidden
      if $el.parent('.fold-block').length is 1
        $el.parentsUntil(@tree).filter('.fold-block').children().unwrap()
        $el.parents().children().removeClass('fold-parent fold-inner').children('a').addClass('open')

      ## Scroll to line if el is offscreen
      $elPos = $el.offset().top
      @treeTop = @tree.offset().top
      @treeBottom = @treeTop + @tree.height()
      unless $elPos > @treeTop and $elPos < @treeBottom
        @tree.scrollTo('.domflag-line.selected')

  tooltipEvents: ->
    $('.tooltip').on 'click', (event) =>
      $domflagStr = '<span class="na domflag-attr">domflag</span>'
      tooltipEl = event.currentTarget
      $parent = $(tooltipEl).parent()

      if $parent.hasClass('domflag-line')
        index = $parent.index('.domflag-line')
        $(tooltipEl).text('Add Domflag')
        $(@panel).find('li').eq(index).remove()
        $parent.removeClass('domflag-line').find('.domflag-attr').remove()
      else
        $(tooltipEl).text('Remove Domflag')
        elString = []
        stringArray = $(tooltipEl).siblings().contents().filter (index) ->
          unless @data.match(/\>/g) ## unless closing tag
            string = @data
            string = @data.toUpperCase() + " " if index == 0
            elString.push string.replace(/</g,' ').replace(/\= /, '=') ## formatting cleanup
        $parent.addClass('domflag-line').find('.s').last().after($domflagStr)
        index = $parent.index('.domflag-line')
        flagItem = "<li class='flag new'>#{elString.join("")}</li>"

        if index < $('ol.flags li').length
          $('ol.flags li').eq(index).before(flagItem)
        else
          $('ol.flags').append(flagItem)
