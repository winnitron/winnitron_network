(function(window, $, undefined) {

  csrf_token = $("meta[name='csrf-token']").attr("content");
  game_id = null;

  $(function() {
    $(".open-playlist-modal").click(function() {
      game_id = parseInt($(this).attr("data-game-id"));
      addPlaylistChecks()
    });

    $("#playlistModal").on("hidden.bs.modal", function (e) {
      $("span.playlist-check").addClass("invisible");
    });

    $(".add-to-playlist a").click(function(e) {
      e.preventDefault();

      var playlist_id = $(this).attr("href");

      console.log("game: " + game_id + ", playlist: " + playlist_id);

      $.ajax({
        type: "POST",
        url:  "/listings",
        data: {
          game_id: game_id,
          playlist_id: playlist_id,
          authenticity_token: csrf_token
        },
        success: function() {
          $(".add-to-playlist a[href='" + playlist_id + "'] span.playlist-check").removeClass("invisible");
        }
      })
    });
  });


  function addPlaylistChecks() {
    $.ajax({
      type: "GET",
      url: "/playlists/all_listings",
      success: function(data) {
        for (playlist_id in data) {
          var game_ids = data[playlist_id]

          var check = $(".add-to-playlist a[data-playlist-id='" + playlist_id + "'] .playlist-check");

          if (game_ids.includes(game_id)) {
            check.removeClass("invisible");
          }

        }
      }
    })
  }

})(window, jQuery)

