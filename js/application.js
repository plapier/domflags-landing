// Generated by CoffeeScript 1.6.3
(function() {
  var SetupDemo;

  $(document).ready(function() {
    return new SetupDemo();
  });

  SetupDemo = (function() {
    function SetupDemo() {
      this.panel = $('.domflags-panel');
      this.tree = $('.dom-tree');
      this.treeLines = this.tree.find('code > span');
      this.treeFlags = this.getTreeFlags();
      this.setupTree();
      this.demoEvents();
      this.panelEvents();
      this.tooltipEvents();
    }

    SetupDemo.prototype.getTreeFlags = function() {
      return this.tree.find('span').filter(function() {
        if ($(this).hasClass('s')) {
          $(this).parent().addClass('flaggable');
        }
        return $(this).text() === "domflag";
      });
    };

    SetupDemo.prototype.setupTree = function() {
      var tooltipStr;
      tooltipStr = '<span class="tooltip">Add Domflag</span>';
      this.treeFlags.addClass('domflag-attr').parent().addClass('domflag-line');
      this.treeLines.find('span:last-of-type').after(tooltipStr).end().filter('.domflag-line').find('.tooltip').text('Remove Domflag');
      return $('#line-2').addClass('non-flaggable');
    };

    SetupDemo.prototype.demoEvents = function() {
      var _this = this;
      return $('#start-demo').on('click', function(event) {
        $(event.currentTarget).addClass('hide');
        $('.devtools-toolbar, .devtools').addClass('open');
        _this.panel.addClass('open').find('li:first-child').addClass('demo');
        return false;
      });
    };

    SetupDemo.prototype.panelEvents = function() {
      var _this = this;
      return this.panel.on('click', 'li', function(event) {
        var $el, $elPos, $target, index;
        index = _this.panel.find('li').index(event.currentTarget);
        $el = _this.tree.find('.domflag-line').eq(index);
        $target = $('.target');
        if ($(event.currentTarget).hasClass('demo') && index < 2) {
          $target.addClass("pos-" + (index + 1));
          $(event.currentTarget).next().addClass('demo');
        } else {
          $target.hide();
        }
        _this.panel.find('li').removeClass('active').end().find(event.currentTarget).addClass('active').removeClass('demo new');
        _this.tree.find('span').removeClass('selected');
        $el.addClass('selected');
        $elPos = $el.offset().top;
        _this.treeTop = _this.tree.offset().top;
        _this.treeBottom = _this.treeTop + _this.tree.height();
        if (!($elPos > _this.treeTop && $elPos < _this.treeBottom)) {
          return _this.tree.scrollTo('.domflag-line.selected');
        }
      });
    };

    SetupDemo.prototype.tooltipEvents = function() {
      var _this = this;
      return $('.tooltip').on('click', function(event) {
        var $domflagStr, $parent, elString, flagItem, index, stringArray;
        $domflagStr = '<span class="na domflag-attr">domflag</span>';
        $parent = $(event.currentTarget).parent();
        if ($parent.hasClass('domflag-line')) {
          index = $parent.index('.domflag-line');
          $(event.currentTarget).text('Add Domflag');
          $(_this.panel).find('li').eq(index).remove();
          return $parent.removeClass('domflag-line').find('.domflag-attr').remove();
        } else {
          $(event.currentTarget).text('Remove Domflag');
          elString = [];
          stringArray = $(event.currentTarget).siblings().contents().filter(function(index) {
            var string;
            if (!this.data.match(/\>/g)) {
              string = this.data;
              if (index === 0) {
                string = this.data.toUpperCase() + " ";
              }
              return elString.push(string.replace(/</g, ' ').replace(/\= /, '='));
            }
          });
          $parent.addClass('domflag-line').find('.s').after($domflagStr);
          index = $parent.index('.domflag-line');
          flagItem = "<li class='flag new'>" + (elString.join("")) + "</li>";
          if (index < $('ol.flags li').length) {
            return $('ol.flags li').eq(index).before(flagItem);
          } else {
            return $('ol.flags').append(flagItem);
          }
        }
      });
    };

    return SetupDemo;

  })();

}).call(this);
