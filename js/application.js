// Generated by CoffeeScript 1.6.3
(function() {
  $(document).ready(function() {
    var $panel, $tree, $treeFlags;
    $panel = $('.domflags-panel');
    $tree = $('.dom-tree');
    $treeFlags = $tree.find('span').filter(function() {
      if ($(this).hasClass('s')) {
        $(this).parent().addClass('flaggable');
      }
      return $(this).text() === "domflag";
    });
    $treeFlags.addClass('domflag-attr').parent().addClass('domflag-line');
    $panel.on('click', 'li', function() {
      var $el, $elPos, $treeBottom, $treeTop, index;
      if ($(this).eq(0).hasClass('demo')) {
        $('a.target').addClass('second');
      } else {
        $('a.target').hide();
      }
      index = $panel.find('li').index(this);
      $el = $tree.find('.domflag-line').eq(index);
      $panel.find('li').removeClass('active');
      $(this).addClass('active').removeClass('demo new');
      $tree.find('span').removeClass('selected');
      $el.addClass('selected');
      $elPos = $el.offset().top;
      $treeTop = $tree.offset().top;
      $treeBottom = $treeTop + $tree.height();
      if (!($elPos > $treeTop && $elPos < $treeBottom)) {
        return $tree.scrollTo('.domflag-line.selected');
      }
    });
    $('#start-demo').on('click', function() {
      $(this).addClass('hide');
      $('.devtools-toolbar').addClass('open');
      $('.devtools').addClass('open');
      $panel.addClass('open');
      $panel.find('li:first-child').addClass('demo');
      return false;
    });
    $('.dom-tree code > span').find('span:last-of-type').after('<span class="tooltip">Add Domflag</span>');
    $('#line-2').addClass('non-flaggable');
    $('.domflag-line').find('.tooltip').text('Remove Domflag');
    return $('.tooltip').on('click', function() {
      var $domflagStr, $parent, elString, flagItem, index, stringArray;
      $domflagStr = '<span class="na domflag-attr">domflag</span>';
      $parent = $(this).parent();
      if ($parent.hasClass('domflag-line')) {
        $(this).text('Add Domflag');
        index = $parent.index('.domflag-line');
        $panel.find('li').eq(index).remove();
        return $parent.removeClass('domflag-line').find('.domflag-attr').remove();
      } else {
        $(this).text('Remove Domflag');
        elString = [];
        stringArray = $(this).siblings().contents().filter(function(index) {
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
  });

}).call(this);
