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
  });
})(window, jQuery)