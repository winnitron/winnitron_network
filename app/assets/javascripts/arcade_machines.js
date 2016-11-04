(function(window, $, undefined) {

  $(function() {

    $("button.machine-save").click(function(e) {
      $("form.machine").submit();
    });

  });
})(window, jQuery)