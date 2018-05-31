(function(window, $, undefined) {

  $(function() {
    $(".games .card").hover(function() {
      $(this).addClass("active");
    },
    function() {
      $(this).removeClass("active");
    });

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
        $("form#save-keys input[type='submit']").removeAttr("disabled");
        $(".custom-warning").css("visibility", "visible");
      } else {
        $("form#save-keys input[type='submit']").attr("disabled", "disabled");
        $(".custom-warning").css("visibility", "hidden");
      }
    });

    $("form#save-keys").on("ajax:send", function(e, data, status, xhr) {
      var button = $("form#save-keys input[type='submit']")
      button.val("Saving custom keys...");
      button.attr("disabled", "disabled");
    }).on("ajax:success", function(e, data, status, xhr) {
      var button = $("form#save-keys input[type='submit']")
      button.val("Save custom keys");
      $("#save-keys-check").show().fadeOut(2000);
      $("form#save-keys input[type='submit']").removeAttr("disabled");
    }).on("ajax:error", function(e, data, status, xhr) {
      console.log("there was a problem");
    });

    $(".template-select button.apply-template").click(function(e) {
      e.preventDefault();

      var template = $("select.template").val();
      $("input[name='template'").val(template);

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

    $(".modal.select-key-modal button.save").click(function(e) {
      var oldValue = $(this).closest(".key").find(".current-key input").val()
      var newValue = $(this).closest(".modal").find(".custom-key-display").html();

      $(this).closest(".key").find(".current-key a").html(newValue);
      $(this).closest(".key").find(".current-key input").val(newValue);

      if (newValue != oldValue) {
        $("select.template").val("custom").trigger("change");
        $("input[name='template'").val("custom");
      }

      highlightKeyboard();
    });

    $(".modal.select-key-modal button.cancel").click(function(e) {
      var oldValue = $(this).closest(".key").find(".current-key a").html();
      $(this).closest(".modal").find(".custom-key-display").html(oldValue);
    });

    highlightKeyboard();

    $("body").keydown(function(e) {
      var key = keyCodeToAHK(e.keyCode);
      if (key.ahk != undefined)
        $(".modal.select-key-modal.show .custom-key-display").html(key.ahk);
    });
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

  function keyCodeToAHK(keyCode) {
    var key = KEY_TRANSLATION["keys"].filter(function(map) {
      return map.keycode == keyCode;
    });

    if (key[0] === undefined) {
      console.warn("Unknown keyCode: " + keyCode);
      return {
        name: null,
        ahk: null
      }
    } else {
      return key[0];
    }
  }

})(window, jQuery)

