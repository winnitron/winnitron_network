(function(window, $, undefined) {

  $(".collapse-arrow").click(function (e) {
      e.preventDefault();
      $(this).siblings(".the-games").toggle("fast");

      if ($(this).html() == "►")
        $(this).html("▼")
      else
        $(this).html("►")

    });

})(window, jQuery);