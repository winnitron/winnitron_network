(function(window, $, undefined) {

  $(function() {

    $("button.game-save").click(function(e) {
      $(this).html("Wait for it...");
      $(this).attr("disabled", "disabled");
      $("form.game").submit();
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
      if ($(".executable-filename").val().length <= 4)
        $("#zipfile-uploader .btn").addClass("disabled");
      else
        $("#zipfile-uploader .btn").removeClass("disabled");
    });

  });
})(window, jQuery)