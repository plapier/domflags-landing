// Generated by CoffeeScript 1.7.1
(function() {
  var SetupDemo;

  $(document).ready(function() {
    return new SetupDemo();
  });

  SetupDemo = (function() {
    function SetupDemo() {
      this.panel = $('.domflags-panel');
      this.tree = $('.dom-tree');
      this.treeFlags = this.getTreeFlags();
      this.tooltipStr = '<span class="tooltip">Add Domflag</span>';
      this.folds = [
        {
          start: 30,
          end: 35
        }, {
          start: 26,
          end: 36
        }, {
          start: 25,
          end: 38
        }, {
          start: 18,
          end: 21
        }, {
          start: 15,
          end: 22
        }, {
          start: 14,
          end: 23
        }, {
          start: 8,
          end: 12
        }, {
          start: 7,
          end: 39
        }, {
          start: 6,
          end: 40
        }, {
          start: 4,
          end: 41
        }
      ];
      this.demoEvents();
    }

    SetupDemo.prototype.getTreeFlags = function() {
      return this.tree.find('span').filter(function() {
        if ($(this).hasClass('s')) {
          $(this).parent().addClass('flaggable');
        }
        return $(this).text() === "domflag";
      });
    };

    SetupDemo.prototype.initTree = function() {
      this.setupTreeNodes();
      this.foldBlocks(this.folds);
      this.foldingEvents();
      this.panelEvents();
      return this.tooltipEvents();
    };

    SetupDemo.prototype.setupTreeNodes = function() {
      var $treeLines;
      this.treeFlags.addClass('domflag-attr').parent().addClass('domflag-line');
      $treeLines = this.tree.find('code > span');
      $treeLines.find('span:last-of-type').after(this.tooltipStr).end().filter('.domflag-line').find('.tooltip').text('Remove Domflag');
      return $('#line-2').addClass('non-flaggable');
    };

    SetupDemo.prototype.foldingEvents = function() {
      return $('.fold-true').on('click', 'a', (function(_this) {
        return function(event) {
          var $parent, foldObject, spanID;
          $parent = $(event.delegateTarget).parent();
          if ($parent.hasClass('fold-block')) {
            return _this.unfoldBlock(event.delegateTarget);
          } else {
            spanID = parseInt($(event.delegateTarget)[0].id.replace(/\D/g, ''));
            foldObject = $.grep(_this.folds, function(obj) {
              return obj.start === spanID;
            });
            return _this.foldBlocks(foldObject);
          }
        };
      })(this));
    };

    SetupDemo.prototype.unfoldBlock = function(target) {
      var leftVal;
      leftVal = parseInt($(target).parent().css('padding-left'));
      $(target).removeClass('fold-parent').attr('style', '').siblings().removeClass('fold-parent fold-inner').unwrap();
      return $(target).children('a').addClass('open');
    };

    SetupDemo.prototype.foldBlocks = function(folds) {
      var $block, $end, $inner, $paddingLeft, $start, blockStr, fold, _i, _len, _results;
      _results = [];
      for (_i = 0, _len = folds.length; _i < _len; _i++) {
        fold = folds[_i];
        $start = this.tree.find("#line-" + fold.start);
        $end = this.tree.find("#line-" + fold.end);
        $inner = this.tree.find($start).nextUntil($end);
        $block = this.tree.find("#line-" + (fold.start - 1)).nextUntil("#line-" + (fold.end + 1));
        $paddingLeft = Math.ceil($start.find('span:first-of-type').offset().left - this.tree.offset().left);
        $start.addClass('fold-true fold-parent').children('a').css('left', "" + $paddingLeft + "px").removeClass('open');
        $end.addClass('fold-parent');
        $inner.addClass('fold-inner');
        blockStr = "<div class='fold-block' style='padding-left: " + $paddingLeft + "px' />";
        _results.push($block.wrapAll(blockStr));
      }
      return _results;
    };

    SetupDemo.prototype.demoEvents = function() {
      return $('#start-demo').on('click', (function(_this) {
        return function(event) {
          $(event.currentTarget).addClass('hide').parent().addClass('show-download');
          $('.devtools-toolbar, .devtools').addClass('open');
          _this.panel.addClass('open').find('li:first-child').addClass('demo');
          _this.initTree();
          return false;
        };
      })(this));
    };

    SetupDemo.prototype.panelEvents = function() {
      $('.devtools').on("transitionend webkitTransitionEnd", function() {
        $('.browser').addClass('open');
        $('#start-demo').addClass('hide');
        return $('#download').addClass('show');
      });
      return this.panel.on('click', 'li', (function(_this) {
        return function(event) {
          var $el, $elPos, $target, index;
          index = _this.panel.find('li').index(event.currentTarget);
          $el = _this.tree.find('.domflag-line').eq(index);
          $target = $('.target');
          if (index < 1) {
            $target.addClass("pos-" + (index + 1));
            $(event.currentTarget).next().addClass('demo');
          } else {
            $target.hide();
          }
          _this.panel.find('li').removeClass('active').end().find(event.currentTarget).addClass('active').removeClass('demo new');
          _this.tree.find('span').removeClass('selected');
          $el.addClass('selected');
          if ($el.parent('.fold-block').length === 1) {
            $el.parentsUntil(_this.tree).filter('.fold-block').children().unwrap();
            $el.parents().children().removeClass('fold-parent fold-inner').children('a').addClass('open');
          }
          $elPos = $el.offset().top;
          _this.treeTop = _this.tree.offset().top;
          _this.treeBottom = _this.treeTop + _this.tree.height();
          if (!($elPos > _this.treeTop && $elPos < _this.treeBottom)) {
            return _this.tree.scrollTo('.domflag-line.selected');
          }
        };
      })(this));
    };

    SetupDemo.prototype.tooltipEvents = function() {
      var panelWidth;
      panelWidth = this.panel.outerWidth();
      return $('.tooltip').on('click', (function(_this) {
        return function(event) {
          var $domflagStr, $panelEl, $parent, $treeIndex, elString, flagItem, tooltipEl;
          $domflagStr = '<span class="na domflag-attr">domflag</span>';
          tooltipEl = event.currentTarget;
          $parent = $(tooltipEl).parent();
          $panelEl = _this.panel.find('li');
          elString = [];
          if ($parent.hasClass('domflag-line')) {
            $treeIndex = $parent.index('.domflag-line');
            $(tooltipEl).text('Add Domflag');
            $panelEl.eq($treeIndex).addClass('remove');
            _this.addSlideClasses('up', $treeIndex);
            _this.slidePanelItems('up', $treeIndex);
            return $parent.removeClass('domflag-line').find('.domflag-attr').remove();
          } else {
            $(tooltipEl).text('Remove Domflag');
            $(tooltipEl).siblings().contents().filter(function($treeIndex) {
              var string;
              if (!this.data.match(/\>/g)) {
                string = this.data;
                if ($treeIndex === 0) {
                  string = this.data.toUpperCase() + " ";
                }
                return elString.push(string.replace(/</g, ' ').replace(/\= /, '='));
              }
            });
            $parent.addClass('domflag-line').find('.s').last().after($domflagStr);
            $treeIndex = $parent.index('.domflag-line');
            flagItem = "<li class='flag new animate' style='width: " + panelWidth + "px'><span>" + (elString.join("")) + "</span></li>";
            if ($treeIndex < $panelEl.length) {
              $panelEl.eq($treeIndex).before(flagItem);
              _this.addSlideClasses('down', $treeIndex);
            } else {
              _this.panel.find('ol').append(flagItem);
            }
            return _this.slidePanelItems('down', $treeIndex);
          }
        };
      })(this));
    };

    SetupDemo.prototype.addSlideClasses = function(elDir, index) {
      return this.panel.find('li').eq(index).nextUntil().each(function(index) {
        return $(this).addClass("delay-" + index + " move-" + elDir);
      });
    };

    SetupDemo.prototype.slidePanelItems = function(elDir, index) {
      var $els, $panelIndex, animationEnd, count, transitionEnd;
      transitionEnd = "webkitTransitionEnd transitionend";
      animationEnd = "webkitAnimationEnd animationend";
      $panelIndex = this.panel.find('li').eq(index);
      $els = this.panel.find(".move-" + elDir);
      count = 1;
      $els.one(transitionEnd, (function(_this) {
        return function(event) {
          if (count === $els.length) {
            $els.removeClass("move-" + elDir).removeClass(function(index, css) {
              return (css.match(/\bdelay-\S+/g) || []).join(" ");
            });
            $panelIndex.removeClass('animate');
            if (elDir === "up") {
              $panelIndex.remove();
            }
          }
          return count++;
        };
      })(this));
      if ($els.length === 0) {
        return $panelIndex.one(animationEnd, (function(_this) {
          return function() {
            $panelIndex.removeClass('animate');
            if (elDir === 'up') {
              return $panelIndex.remove();
            }
          };
        })(this));
      }
    };

    return SetupDemo;

  })();

}).call(this);
