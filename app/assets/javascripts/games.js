(function(window, $, undefined) {

  $(function() {

    $("button.game-save").click(function(e) {
      if ($("form.game")[0].checkValidity()) {
        $(this).html("Wait for it...");
        $(this).attr("disabled", "disabled");
      }

      $("#submit").click();
    });


    $(".add_nested_fields_link").click();


    $("#zipfile-uploader").bind("s3_upload_complete", function(e, content) {
      $.ajax({
        type: "PUT",
        url:  "/games/" + content.game_uuid + "/zips/" + content.filepath,
        data: { "executable": $(".executable-filename").val() }
      })

      $("#current-zip").html(content.filename);

      var today = new Date();
      var months = ["January", "February", "March", "April", "May", "June",
                    "July", "August", "September", "October", "November", "December"]
      var datestr = months[today.getMonth()] + " " + today.getDate() + ", " + today.getFullYear();
      $("#zip-uploaded-date .date").html(datestr);
    });


    $("#zipfile-uploader .btn").addClass("disabled");
    $(".executable-filename").keyup(function(e) {
      $(".js-executable-file").val($(".executable-filename").val());

      if ($(".executable-filename").val().length <= 4)
        $("#zipfile-uploader .btn").addClass("disabled");
      else
        $("#zipfile-uploader .btn").removeClass("disabled");
    });


    $(".popular-tags .js-add-tag").click(function(e) {
      e.preventDefault();
      var field = $(".js-tag-list")
      field.tagsinput("add", $(this).attr("href"))
    })

  });
})(window, jQuery)