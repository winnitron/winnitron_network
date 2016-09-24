(function(window, $, undefined) {
  $(function() {
    $(".collapse-arrow").click(function (e) {
      e.preventDefault();
      $(this).siblings(".the-games").toggle("fast");
      $(this).siblings(".the-playlists").toggle("fast");

      if ($(this).html() == "►")
        $(this).html("▼")
      else
        $(this).html("►")

    });
  });

})(window, jQuery)