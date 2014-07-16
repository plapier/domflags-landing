(function(){var e,t,n=function(e,t){return function(){return e.apply(t,arguments)}};$(document).ready(function(){var n,o;return new e,new t,o=function(){var e;return e="Thanks for installing :)",document.getElementById("marketing-install").text=e,document.getElementById("hero-install").text=e,$("#hero-install, #marketing-install, #link-install").off("click"),trackInstall("Success")},n=function(){return trackInstall("Failure")},$("#hero-install, #marketing-install, #link-install").on("click",function(){return chrome.webstore.install("https://chrome.google.com/webstore/detail/nindoglnpjcjoaheijieagogboabafkc",o,n),!1})}),t=function(){function e(){this.readMore=document.getElementById("readMore"),window.onscroll=this.hideReadMore}return e.prototype.hideReadMore=function(){var e;return e=(1-.0035*window.pageYOffset).toFixed(2),e>-.1&&(this.readMore.style.opacity=e),window.pageYOffset>=window.innerHeight?(this.readMore.style.display="none",window.onscroll=null):void 0},e}(),e=function(){function e(){this.initTree=n(this.initTree,this),this.transitionEnd="webkitTransitionEnd transitionend",this.animationEnd="webkitAnimationEnd animationend",this.browser=$(".browser"),this.startDemo=$("#start-demo"),this.devtools=$(".devtools"),this.panel=$(".domflags-panel"),this.tree=$(".dom-tree"),this.treeFlags=this.getTreeFlags(),this.tooltipStr='<span class="tooltip">Add Domflag</span>',this.treeTooltip1=document.getElementById("ft-tooltip-1"),this.treeTooltip2=document.getElementById("ft-tooltip-2"),this.panelTooltip=document.getElementById("ft-tooltip-panel"),this.folds=[{start:18,end:21},{start:15,end:22},{start:14,end:23},{start:8,end:12},{start:7,end:24},{start:6,end:25},{start:4,end:26}],this.demoEvents(),this.setupTreeNodes(),this.initTree()}return e.prototype.getTreeFlags=function(){return this.tree.find("span").filter(function(){return $(this).hasClass("s")&&$(this).parent().addClass("flaggable"),"domflag"===$(this).text()})},e.prototype.initTree=function(){return $("#hero").on(this.animationEnd,".browser",function(e){return function(t){return t.target.classList.contains("browser")?(e.foldBlocks(e.folds),e.foldingEvents(),e.panelEvents(),e.tooltipEvents(),$(t.delegateTarget).off()):void 0}}(this))},e.prototype.setupTreeNodes=function(){var e;return this.treeFlags.addClass("domflag-attr").parent().addClass("domflag-line"),e=this.tree.find("code > span"),e.find("span:last-of-type").after(this.tooltipStr).end().filter(".domflag-line").find(".tooltip").text("Remove Domflag"),$("#line-2").addClass("non-flaggable")},e.prototype.foldingEvents=function(){return $(".fold-true").on("click","a",function(e){return function(t){var n,o,s;return n=$(t.delegateTarget).parent(),n.hasClass("fold-block")?e.unfoldBlock(t.delegateTarget):(s=parseInt($(t.delegateTarget)[0].id.replace(/\D/g,"")),o=$.grep(e.folds,function(e){return e.start===s}),e.foldBlocks(o))}}(this))},e.prototype.unfoldBlock=function(e){var t;return t=$(e),t.removeClass("fold-parent").attr("style","").siblings().removeClass("fold-parent fold-inner").unwrap(),t.children("a").addClass("open")},e.prototype.foldBlocks=function(e){var t,n,o,s,i,r,l,a,d,f;for(f=[],a=0,d=e.length;d>a;a++)r=e[a],s=this.tree.find("#line-"+r.start),n=this.tree.find("#line-"+r.end),o=this.tree.find(s).nextUntil(n),t=this.tree.find("#line-"+(r.start-1)).nextUntil("#line-"+(r.end+1)),l=Math.ceil(s.find("span:first-of-type").offset().left-this.tree.offset().left),s.addClass("fold-true fold-parent").children("a").css("left",""+l+"px").removeClass("open"),n.addClass("fold-parent"),o.addClass("fold-inner"),i="<div class='fold-block' style='padding-left: "+l+"px' />",f.push(t.wrapAll(i));return f},e.prototype.demoEvents=function(){var e,t;return e=$(".devtools-toolbar"),this.startDemo.on("click",function(t){return function(n){return $(n.currentTarget).addClass("hide").parent().addClass("show-download"),e[0].classList.add("open"),t.devtools.addClass("open"),!1}}(this)),t=$(".will-change"),this.browser.on(this.transitionEnd,".devtools",function(e){return function(n){return t.removeClass("will-change"),e.panel[0].classList.add("open"),$(n.delegateTarget).off()}}(this))},e.prototype.panelEvents=function(){var e;return e=$("#hero-install"),this.devtools.on(this.transitionEnd,function(t){return function(){return t.browser.addClass("open"),t.startDemo.addClass("hide"),e.addClass("show")}}(this)),this.panel.on("mouseover",function(e){return function(){return e.panelTooltip.style.display="block",e.panel.off("mouseover")}}(this)),this.panel.on("click","li",function(e){return function(t){var n,o,s;return s=e.panel.find("li").index(t.currentTarget),n=e.tree.find(".domflag-line").eq(s),e.panelTooltip.style.display="none",e.treeTooltip1.style.display="none",e.treeTooltip2.style.display="none",0===s&&t.currentTarget.classList.contains("demo")?(e.treeTooltip1.style.display="block",$(t.currentTarget).next().addClass("demo")):1===s&&t.currentTarget.classList.contains("demo")&&(e.treeTooltip2.style.display="block",e.tree.removeClass("hide-tooltips"),document.getElementById("readMore").classList.add("show")),e.panel.find("li").removeClass("active").end().find(t.currentTarget).addClass("active").removeClass("demo new"),e.tree.find("span").removeClass("selected"),n.addClass("selected"),1===n.parent(".fold-block").length&&(n.parentsUntil(e.tree).filter(".fold-block").children().unwrap(),n.parents().children().removeClass("fold-parent fold-inner").children("a").addClass("open")),o=n.offset().top,e.treeTop=e.tree.offset().top,e.treeBottom=e.treeTop+e.tree.height(),o>e.treeTop&&o<e.treeBottom?void 0:e.tree.scrollTo(".domflag-line.selected")}}(this))},e.prototype.tooltipEvents=function(){var e,t;return t=this.panel.outerWidth(),e='<span class="na domflag-attr">domflag</span>',$(".tooltip").on("click",function(n){return function(o){var s,i,r,l,a,d;return d=o.currentTarget,i=$(d).parent(),s=n.panel.find("li"),l=[],(n.treeTooltip2.style.display="show")&&(n.treeTooltip2.style.display="none"),i.hasClass("domflag-line")?(r=i.index(".domflag-line"),$(d).text("Add Domflag"),s.eq(r).addClass("remove"),n.addSlideClasses("up",r),n.slidePanelItems("up",r),i.removeClass("domflag-line").find(".domflag-attr").remove()):($(d).text("Remove Domflag"),$(d).siblings().contents().filter(function(e){var t;return this.data.match(/\>/g)?void 0:(t=this.data,0===e&&(t=this.data.toUpperCase()+" "),l.push(t.replace(/</g," ").replace(/\= /,"=")))}),i.addClass("domflag-line").find(".s").last().after(e),r=i.index(".domflag-line"),a="<li class='flag new animate' style='width: "+t+"px'><span>"+l.join("")+"</span></li>",r<s.length?(s.eq(r).before(a),n.addSlideClasses("down",r)):n.panel.find("ol").append(a),n.slidePanelItems("down",r))}}(this))},e.prototype.addSlideClasses=function(e,t){return this.panel.find("li").eq(t).nextUntil().each(function(t){return $(this).addClass("delay-"+t+" move-"+e)})},e.prototype.slidePanelItems=function(e,t){var n,o,s;return o=this.panel.find("li").eq(t),n=this.panel.find(".move-"+e),s=1,n.one(this.transitionEnd,function(){return function(){return s===n.length&&(n.removeClass("move-"+e).removeClass(function(e,t){return(t.match(/\bdelay-\S+/g)||[]).join(" ")}),o.removeClass("animate"),"up"===e&&o.remove()),s++}}(this)),0===n.length?o.one(this.animationEnd,function(){return function(){return o.removeClass("animate"),"up"===e?o.remove():void 0}}(this)):void 0},e.prototype.trackEvent=function(e){return _gaq.push(["_trackEvent",e,"clicked"])},e}()}).call(this);