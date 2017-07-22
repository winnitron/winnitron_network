(function(window, $, undefined) {

  $(function() {
    $(".add_nested_fields_link").click();

    $(".popular-tags .js-add-tag").click(function(e) {
      e.preventDefault();
      var field = $(".js-tag-list")
      field.tagsinput("add", $(this).attr("href"))
    })

    $("#zipfile-uploader").bind("s3_upload_complete", function(e, content) {
      $(".next-step").removeClass("disabled");
    });


    $(".template-select select").change(function (e) {
      if ($(this).val() == "custom") {
        $(".custom-warning").css("visibility", "visible");
      } else {
        $(".custom-warning").css("visibility", "hidden");
      }
    });
  });
})(window, jQuery)