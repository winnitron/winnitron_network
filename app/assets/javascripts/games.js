(function(window, $, undefined) {

  $(function() {

    $("button.game-save").click(function(e) {
      $("form.game").submit();
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




    $("#image-uploader").bind("s3_upload_complete", function(e, content) {
      img = '<img src="' + content.url + '">';
      link = '<a href="' + content.url + '" class="screenshot">' + img + '</a>';
      $(".current-images").append(link)
    })


  });
})(window, jQuery)