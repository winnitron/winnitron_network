(function(window, $, undefined) {

  $(function() {

    $("button.machine-save").click(function(e) {
      if ($("form.machine")[0].checkValidity()) {
        $(this).html("Wait for it...");
        $(this).attr("disabled", "disabled");
      }
      $("#submit").click();
    });

  });
})(window, jQuery)