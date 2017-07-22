(function(window, $, undefined) {

  $(function() {
    $(".nav .tab a").click(function(e) {
      $(this).parents("li.tab").siblings("li.tab").removeClass("active");
      $(this).parents("li.tab").addClass("active");


      $(".tab-content .tab-pane").removeClass("active");
      $(".tab-content .tab-pane" + $(this).attr("href")).addClass("active");
    })

    var tab = $(".nav .tab").first().addClass("active");
    var content = tab.children("a").first().attr("href");
    $(".tab-content .tab-pane" + content).addClass("active");
  });

})(window, jQuery);