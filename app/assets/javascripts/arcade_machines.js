(function(window, $, undefined) {

  $(function() {

    $("button.machine-save").click(function(e) {
      $(this).html("Wait for it...");
      $(this).attr("disabled", "disabled");
      $("form.machine").submit();
    });

  });
})(window, jQuery)