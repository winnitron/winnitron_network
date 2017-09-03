(function(window, $, undefined) {

  $(function() {

    $("button.approval-request").click(function(e) {

      if ($("form.approval-request")[0].checkValidity()) {
        $("form.approval-request").submit();
      }
    });

  });
})(window, jQuery)