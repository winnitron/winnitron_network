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

    $(".template-select button.apply-template").click(function(e) {
      e.preventDefault();

      var template = $("select.template").val();

      if (template == "custom")
        return;

      $.get("/key_maps", function(templates) {
        var keyMap = templates[template];

        for (var p = 1; p <= 4; p++) {
          for (var control in keyMap[p]) {
            var key = keyMap[p][control];

            $(".player" + p + " ." + control + " a.ahk-key").html(key);
          }
        }

        highlightKeyboard();
      });

    });


    highlightKeyboard();
  });

  function resetKeyboard() {
    $("#keyboard li.symbol, #keyboard li.letter").css("background-color", "#f0f0f0");
    $("#keyboard li.symbol, #keyboard li.letter").css("color", "black");
  }

  function highlightKeyboard() {
    resetKeyboard();

    colors = [undefined,
      "#404cbf",
      "#bf4055",
      "#46bf40",
      "#bfb640"
    ];

    for(var player = 1; player <= 4; player++) {
      $(".player" + player + " a.ahk-key").each(function(i, element) {
        var key = element.text.trim();
        $("#keyboard li[data-ahk='" + key + "'").css("background-color", colors[player]);
        $("#keyboard li[data-ahk='" + key + "'").css("color", "white");
      });
    }

  }

})(window, jQuery)