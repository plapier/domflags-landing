$(document).ready ->
  console.warn "%c DomFlags Note: there is a bug in DevTools that crashes the tab when certain elements are inspected programatically, eg. iframes & images. An issue has been opened.",  "font-weight: bold;"
  new SetupDemo()
  new SetupReadMore()
  new GfyControl()

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
 
class SetupReadMore
  constructor: ->
    @readMore = document.getElementById 'readMore'
    window.onscroll = @hideReadMore

  hideReadMore:  ->
    opacityVal = (1 - window.pageYOffset * 0.0035).toFixed(2)
    @readMore.style.opacity = opacityVal if opacityVal > -0.1

    if window.pageYOffset >= window.innerHeight
      @readMore.style.display = "none"
      window.onscroll = null

class GfyControl
  constructor: ->
    video = document.getElementById('demo-gif')
    video.pause()

    video.addEventListener 'mouseover', ->
      video.currentTime = 0
      video.play()

    video.addEventListener 'mouseout', ->
      video.pause()

class SetupDemo
  constructor: ->
    @transitionEnd = "webkitTransitionEnd transitionend"
    @animationEnd  = "webkitAnimationEnd animationend"
    @browser = $('.browser')
    @startDemo = $('#start-demo')
    @devtools = $('.devtools')
    @panel = $('.domflags-panel')
    @tree  = $('.dom-tree')
    @treeFlags = @getTreeFlags()
    @tooltipStr = '<span class="tooltip">Add Domflag</span>'
    @treeTooltip1 = document.getElementById('ft-tooltip-1')
    @treeTooltip2 = document.getElementById('ft-tooltip-2')
    @panelTooltip = document.getElementById('ft-tooltip-panel')
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
    @setupTreeNodes()
    @initTree()


  getTreeFlags: ->
    @tree.find('span').filter ->
      if $(@).hasClass('s')
        $(@).parent().addClass('flaggable')
      $(@).text() is "domflag"

  initTree: =>
    $('#hero').on @animationEnd, '.browser', (event) =>
      if event.target.classList.contains "browser"
        @foldBlocks(@folds)
        @foldingEvents()
        @panelEvents()
        @tooltipEvents()
        $(event.delegateTarget).off()

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
    $toolbar = $('.devtools-toolbar')
    @startDemo.on 'click', (event) =>
      $(event.currentTarget).addClass('hide').parent().addClass('show-download')
      $toolbar[0].classList.add('open')
      @devtools.addClass('open')
      false

    $willChange = $('.will-change')
    @browser.on @transitionEnd, '.devtools', (event) =>
      $willChange.removeClass('will-change')
      @panel[0].classList.add('open')
      $(event.delegateTarget).off()

  panelEvents: ->
    $heroBtn = $('#hero-install')
    @devtools.on @transitionEnd, =>
      @browser.addClass('open')
      @startDemo.addClass('hide')
      $heroBtn.addClass('show')

    @panel.on 'mouseover', (event) =>
      @panelTooltip.style.display = 'block'
      @panel.off 'mouseover'

    @panel.on 'click', 'li', (event) =>
      index = @panel.find('li').index(event.currentTarget)
      $el = @tree.find('.domflag-line').eq(index)

      @panelTooltip.style.display = "none"
      @treeTooltip1.style.display = "none"
      @treeTooltip2.style.display = "none"

      if index is 0 and event.currentTarget.classList.contains('demo')
        @treeTooltip1.style.display = "block"
        $(event.currentTarget).next().addClass('demo')
      else if index is 1 and event.currentTarget.classList.contains('demo')
        @treeTooltip2.style.display = "block"
        @tree.removeClass('hide-tooltips')
        document.getElementById('readMore').classList.add('show')

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

    $domflagStr = '<span class="na domflag-attr">domflag</span>'
    $('.tooltip').on 'click', (event) =>
      tooltipEl = event.currentTarget
      $parent   = $(tooltipEl).parent()
      $panelEl  = @panel.find('li')
      elString  = []

      @treeTooltip2.style.display = "none" if @treeTooltip2.style.display = "show"

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
    $panelIndex = @panel.find('li').eq(index)
    $els = @panel.find(".move-#{elDir}")

    count = 1
    $els.one @transitionEnd, (event) =>
      unless count isnt $els.length
        $els.removeClass("move-#{elDir}").removeClass (index, css) ->
          (css.match(/\bdelay-\S+/g) or []).join " " ## remove delay-* class
        $panelIndex.removeClass('animate')
        $panelIndex.remove() if elDir is "up"
      count++

    ## Remove el if only el in panel
    if $els.length is 0
      $panelIndex.one @animationEnd, =>
        $panelIndex.removeClass('animate')
        $panelIndex.remove() if elDir is 'up'

  trackEvent: (str) ->
    _gaq.push ['_trackEvent', str, 'clicked']
