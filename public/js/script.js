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