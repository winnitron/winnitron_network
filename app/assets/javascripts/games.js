(function(window, $, undefined) {

  $(function() {
    $("#s3-exec-uploader").S3Uploader();

    $("#s3-exec-uploader").bind("s3_upload_complete", function(e, content) {
      $(".js-upload-status").html("Uploading " + content.filename + " complete!");
      $(".js-upload-status").css("visibility", "visible");
      $("pre.js-filename").html(content.filename);
    });

    $(".js-select-all").click(function(e) {
      e.preventDefault();
      $(".js-add-game-to-playlist").prop("checked", true);
    });

    $(".js-select-none").click(function(e) {
      e.preventDefault();
      $(".js-add-game-to-playlist").prop("checked", false);
    });






    $(".game-list .game").draggable({
      containment: ".games",
      revert: true
    });


    $(".playlist").droppable({
      accept: ".game",
      activeClass: "target-active-drop-it-here",
      hoverClass: "target-hover-born-ready",
      drop: function(event, element) {
        var game_id = $(element.draggable).attr("data-game-id");
        var playlist_id = $(this).attr("data-playlist-id");

        $.ajax({
          type: "POST",
          url: "/listings",
          contentType: "application/json",
          data: JSON.stringify({
            playlist_id: playlist_id,
            game_id: game_id
          }),
          success: function(data, status, response) {
            if (response.status == 201) {
              $.get("/games/" + game_id + ".json",
                function(data) {
                  var game_link = '<a href="' + data.game.link + '">' + data.game.title + '</a>';
                  var game_li = "<li>" + game_link + "</li>";
                  $(".playlist[data-playlist-id=" + playlist_id + "] .the-games ").append(game_li)
                });
            }
          },
          error: function() {
            console.log("Dammit");
          }
        });

      }
    });


    $(".add_nested_fields_link").click();

  });


})(window, jQuery)