$(document).ready ->
  new SetupDemo()

  installSuccess = ->
    ty = "Thanks for installing :)"
    document.getElementById("marketing-install").text = ty
    document.getElementById("hero-install").text = ty
    $('#hero-install, #marketing-install, #link-install').off "click"
    trackInstall("Success")

  installFailure = ->
    trackInstall("Failure")

  $('#hero-install, #marketing-install, #link-install').on "click", ->
    chrome.webstore.install('https://chrome.google.com/webstore/detail/nindoglnpjcjoaheijieagogboabafkc', installSuccess, installFailure)
    return false

class SetupDemo
  constructor: ->
    @panel = $('.domflags-panel')
    @tree  = $('.dom-tree')
    @treeFlags = @getTreeFlags()
    @tooltipStr = '<span class="tooltip">Add Domflag</span>'
    @folds = [
      { start: 18, end: 21 }
      { start: 15, end: 22 }
      { start: 14, end: 23 }
      { start: 8, end: 12 }
      { start: 7, end: 24 }
      { start: 6, end: 25 }
      { start: 4, end: 26 }
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

      if !$parent.hasClass('fold-block')
        spanID = parseInt $(event.delegateTarget)[0].id.replace(/\D/g,'') ## Get line-id
        foldObject = $.grep @folds, (obj) ->
          obj.start is spanID
        @foldBlocks(foldObject)
      else
        @unfoldBlock(event.delegateTarget)

  unfoldBlock: (target) ->
    $target = $(target)
    $target.removeClass('fold-parent').attr('style', '')
      .siblings().removeClass('fold-parent fold-inner').unwrap()
    $target.children('a').addClass('open')

  foldBlocks: (folds) ->
    for fold in folds
      $start = @tree.find("#line-#{fold.start}")
      $end   = @tree.find("#line-#{fold.end}")
      $inner = @tree.find($start).nextUntil($end)
      $block = @tree.find("#line-#{fold.start - 1}").nextUntil("#line-#{fold.end + 1}")
      paddingLeft = Math.ceil $start.find('span:first-of-type').offset().left - @tree.offset().left

      $start.addClass('fold-true fold-parent').children('a').css('left', "#{paddingLeft}px").removeClass('open')
      $end.addClass('fold-parent')
      $inner.addClass('fold-inner')
      blockStr = "<div class='fold-block' style='padding-left: #{paddingLeft}px' />"
      $block.wrapAll(blockStr)

  demoEvents: ->
    ## Add parent OPEN class and refactor
    $('#start-demo').on 'click', (event) =>
      $(event.currentTarget).addClass('hide').parent().addClass('show-download')
      $('.devtools-toolbar, .devtools').addClass('open')
      @panel.addClass('open').find('li:first-child').addClass('demo')
      @initTree() ## initTree after click to fix arrow position bug
      false

  panelEvents: ->
    $('.devtools').on "transitionend webkitTransitionEnd", ->
      $('.browser').addClass('open')
      $('#start-demo').addClass('hide')
      $('#hero-install').addClass('show')

    @panel.on 'click', 'li', (event) =>
      index = @panel.find('li').index(event.currentTarget)
      $el = @tree.find('.domflag-line').eq(index)
      $target = $('.target')

      if index < 2
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
    panelWidth = @panel.outerWidth()

    $('.tooltip').on 'click', (event) =>
      $domflagStr = '<span class="na domflag-attr">domflag</span>'
      tooltipEl = event.currentTarget
      $parent   = $(tooltipEl).parent()
      $panelEl  = @panel.find('li')
      elString  = []

      ## Remove domflags
      if $parent.hasClass('domflag-line')
        $treeIndex = $parent.index('.domflag-line')

        $(tooltipEl).text('Add Domflag')
        $panelEl.eq($treeIndex).addClass('remove')
        @addSlideClasses('up', $treeIndex)
        @slidePanelItems('up', $treeIndex)
        $parent.removeClass('domflag-line').find('.domflag-attr').remove()

      else ## Add domflags
        $(tooltipEl).text('Remove Domflag')
        $(tooltipEl).siblings().contents().filter ($treeIndex) ->
          unless @data.match(/\>/g) ## unless closing tag
            string = @data
            string = @data.toUpperCase() + " " if $treeIndex == 0
            elString.push string.replace(/</g,' ').replace(/\= /, '=') ## formatting cleanup
        $parent.addClass('domflag-line').find('.s').last().after($domflagStr)

        $treeIndex = $parent.index('.domflag-line')
        flagItem = "<li class='flag new animate' style='width: #{panelWidth}px'><span>#{elString.join("")}</span></li>"

        if $treeIndex < $panelEl.length
          $panelEl.eq($treeIndex).before(flagItem)
          @addSlideClasses('down', $treeIndex)
        else
          @panel.find('ol').append(flagItem)

        @slidePanelItems('down', $treeIndex)

  addSlideClasses: (elDir, index) ->
    @panel.find('li').eq(index).nextUntil().each (index) ->
      $(@).addClass("delay-#{index} move-#{elDir}")

  slidePanelItems: (elDir, index) ->
    transitionEnd = "webkitTransitionEnd transitionend"
    animationEnd  = "webkitAnimationEnd animationend"
    $panelIndex = @panel.find('li').eq(index)
    $els = @panel.find(".move-#{elDir}")

    count = 1
    $els.one transitionEnd, (event) =>
      unless count isnt $els.length
        $els.removeClass("move-#{elDir}").removeClass (index, css) ->
          (css.match(/\bdelay-\S+/g) or []).join " " ## remove delay-* class
        $panelIndex.removeClass('animate')
        $panelIndex.remove() if elDir is "up"
      count++

    ## Remove el if only el in panel
    if $els.length is 0
      $panelIndex.one animationEnd, =>
        $panelIndex.removeClass('animate')
        $panelIndex.remove() if elDir is 'up'

  trackEvent: (str) ->
    _gaq.push ['_trackEvent', str, 'clicked']
