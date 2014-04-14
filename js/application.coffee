$(document).ready ->
  myCodeMirror = CodeMirror(document.getElementById('domtree'),
    value: documentStr
    # mode: 'text/html'
    mode: 'htmlmixed'
    readOnly: true
    cursorBlinkRate: 0
    lineWrapping: false
    lineNumbers: false
    foldGutter: true
    foldCode: true
    gutters: ["CodeMirror-linenumbers", "CodeMirror-foldgutter"]
  )

  myCodeMirror.foldCode CodeMirror.Pos(4, 0), widget: "..."
  myCodeMirror.on "change", ->
    console.log "foo"


  new SetupDemo()

class SetupDemo
  constructor: ->
    @panel = $('.domflags-panel')
    @tree  = $('.CodeMirror-code')
    @treeLines = @tree.find('pre > span')
    @treeFlags = @getTreeFlags()
    @setupTree()
    @demoEvents()
    @panelEvents()
    @tooltipEvents()

  getTreeFlags: ->
    @tree.find('span').filter( ->
      if $(@).hasClass('cm-attribute')
        $(@).parent().addClass('flaggable') ## flag parent if not closing bracket
      $(@).text() is "domflag"
    )

  setupTree: ->
    tooltipStr= '<span class="tooltip">Add Domflag</span>'
    @treeFlags.addClass('domflag-attr').parent().addClass('domflag-line')
    @treeLines.find('span:last-of-type').after(tooltipStr).end().filter('.domflag-line').find('.tooltip').text('Remove Domflag')
    $('#line-2').addClass('non-flaggable')

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
      $elPos = $el.offset().top
      treeTop = @tree.offset().top
      treeBottom = treeTop + $('#domtree').height()
      unless $elPos > treeTop and $elPos < treeBottom
        $('.CodeMirror-scroll').scrollTo('.domflag-line.selected')
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
        $parent.addClass('domflag-line').find('.cm-string').after($domflagStr)
        index = $parent.index('.domflag-line')
        flagItem = "<li class='flag new'>#{elString.join("")}</li>"

        if index < $('ol.flags li').length
          $('ol.flags li').eq(index).before(flagItem)
        else
          $('ol.flags').append(flagItem)
    )


documentStr = """
              <!DOCTYPE html>
              <html lang="en">
                <head></head>
                <body data-attr="1">
                  <section class="main">
                    <section class="browser">
                      <div class="header"domflag>
                        <div class="browser-button"></div>
                        <div class="browser-button"></div>
                        <div class="browser-button"></div>
                      </div>
                      <div class="body">..</div>
                      <div class="devtool-toolbar"></div>
                      <section class="devtools"domflag>
                        <div class="domflags-panel">
                          <header class="title">DOMFLAGS</header>
                          <ol class="flags">
                            <li class="flag">DIV class="header"</li>
                            <li class="flag">SECTION class="devtools"</li>
                            <li class="flag">LI class="flag"</li>
                          </ol>
                        </div>
                        <div class="dom-tree">..</div>
                        <div class="dom-properties"domflag>..</div>
                      </section>
                    </section>
                  </section>
                </body>
              </html>
              """
