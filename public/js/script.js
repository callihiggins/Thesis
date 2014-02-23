;(function(a){a.fn.rwdImageMaps=function(){var c=this;var b=function(){c.each(function(){if(typeof(a(this).attr("usemap"))=="undefined"){return}var e=this,d=a(e);a("<img />").load(function(){var g="width",m="height",n=d.attr(g),j=d.attr(m);if(!n||!j){var o=new Image();o.src=d.attr("src");if(!n){n=o.width}if(!j){j=o.height}}var f=d.width()/100,k=d.height()/100,i=d.attr("usemap").replace("#",""),l="coords";a('map[name="'+i+'"]').find("area").each(function(){var r=a(this);if(!r.data(l)){r.data(l,r.attr(l))}var q=r.data(l).split(","),p=new Array(q.length);for(var h=0;h<p.length;++h){if(h%2===0){p[h]=parseInt(((q[h]/n)*100)*f)}else{p[h]=parseInt(((q[h]/j)*100)*k)}}r.attr(l,p.toString())})}).attr("src",d.attr("src"))})};a(window).resize(b).trigger("resize");return this}})(jQuery);

$(window).load(function () {
 $(".navbar").affix({
        offset: { 
            top: $('#nav').offset().top
        }
    });
    
    
    
    });


$( window ).resize(function() {
$('[data-spy="scroll"]').each(function () {
  var $spy = $(this).scrollspy('refresh');
})
});


$(document).ready(function() {
   // $('#main').scrollspy();
  /*  $('#download_anchor').scrollspy(); */
   
  $('img[usemap]').rwdImageMaps();

    
        var headerTop = $('#nav').offset().top;
        var headerBottom = headerTop; // Sub-menu should appear after this distance from top.
        $(window).scroll(function () {
       
            var scrollTop = $(window).scrollTop(); // Current vertical scroll position from the top
            if (scrollTop > headerBottom) { // Check to see if we have scrolled more than headerBottom
                if (($("#nav").is(":visible") === false)) {
                    $('#nav').fadeIn('slow');
                }
            } else {
                if ($("#nav").is(":visible")) {
                    $('#nav').hide();
                }
            }
        });
             });