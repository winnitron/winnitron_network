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


    $(".template-select select").change(function(e) {
      if ($(this).val() == "custom") {
        $(".custom-warning").css("visibility", "visible");
      } else {
        $(".custom-warning").css("visibility", "hidden");
      }
    });

    // TODO:
    // .template-select form submit
    // on success, GET bindings, updateKeySelector()

    for(var p = 1; p <= 4; p++) {
      highlightKeyboard(p);
    }
  });

  function highlightKeyboard(player) {
    colors = [undefined,
      "#404cbf",
      "#bf4055",
      "#46bf40",
      "#bfb640"
    ];

    $(".player" + player + " a.ahk-key").each(function(i, element) {
      var key = element.text.trim();
      $("#keyboard li[data-ahk='" + key + "'").css("background-color", colors[player]);
      $("#keyboard li[data-ahk='" + key + "'").css("color", "white");
    });


  }

})(window, jQuery)