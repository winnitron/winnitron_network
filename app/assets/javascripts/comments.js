(function(window, $, undefined) {

  $(function() {

    $(".comments form").on("ajax:success", function(e, data, status, xhr) {
      $(data).hide().appendTo(".comments .existing").fadeIn("fast");
      $(".comments form textarea").val("");
    }).on("ajax:error", function(e, xhr, status, error) {
    });

  });
})(window, jQuery)