(function(window, $, undefined) {

  $(function() {
    $(".playlist-list .playlist").draggable({
      containment: ".playlists",
      revert: true
    });


    $(".winnitron").droppable({
      accept: ".playlist",
      activeClass: "target-active-drop-it-here",
      hoverClass: "target-hover-born-ready",
      drop: function(event, element) {
        var playlist_id = $(element.draggable).attr("data-playlist-id");
        var winnitron_id = $(this).attr("data-winnitron-id");

        $.ajax({
          type: "POST",
          url: "/subscriptions",
          contentType: "application/json",
          data: JSON.stringify({
            playlist_id: playlist_id,
            arcade_machine_id: winnitron_id
          }),
          success: function(data, status, response) {
            console.log(response.status);

            if (response.status == 201) {
              $.get("/playlists/" + playlist_id + ".json",
                function(data) {
                  var winnitron_link = '<a href="' + data.playlist.link + '">' + data.playlist.title + '</a>';
                  var winnitron_li = "<li>" + winnitron_link + "</li>";
                  $(".winnitron[data-winnitron-id=" + winnitron_id + "] .the-playlists").append(winnitron_li)
                });
            }
          },
          error: function() {
            console.log("oh no");
          }
        });

      }
    });

  });

})(window, jQuery);