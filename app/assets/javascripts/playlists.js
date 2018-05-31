(function(window, $, undefined) {

  csrf_token = $("meta[name='csrf-token']").attr("content");
  game_id = null;
  playlist_id = null;

  $(function() {
    // ---------- ADD PLAYLIST TO MACHINE ----------
    $(".open-machine-modal").click(function() {
      playlist_id = parseInt($(this).attr("data-playlist-id"));
      addMachineChecks()
    });

    $("#machineModal").on("hidden.bs.modal", function (e) {
      $("span.machine-check").addClass("invisible");
    });

    $(".add-to-machine a.existing").click(function(e) {
      e.preventDefault();

      var machine_id = $(this).attr("href");

      $.ajax({
        type: "POST",
        url:  "/subscriptions",
        data: {
          playlist_id: playlist_id,
          arcade_machine_id: machine_id,
          authenticity_token: csrf_token
        },
        success: function() {
          $(".add-to-machine a[href='" + machine_id + "'] span.machine-check").removeClass("invisible");
        }
      })
    });


    // ---------- ADD GAME TO PLAYLIST ----------
    $(".open-playlist-modal").click(function() {
      game_id = parseInt($(this).attr("data-game-id"));

      $("a.create-playlist").attr("href", "/playlists/new?game_id=" + game_id);
      addPlaylistChecks()
    });

    $("#playlistModal").on("hidden.bs.modal", function (e) {
      $("span.playlist-check").addClass("invisible");
    });

    $(".add-to-playlist a.existing-playlist").click(function(e) {
      e.preventDefault();

      var playlist_id = $(this).attr("href");

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


  function addMachineChecks() {
    $.ajax({
      type: "GET",
      url: "/arcade_machines/all_subscriptions",
      success: function(data) {
        for (machine_id in data) {
          var playlist_ids = data[machine_id]

          var check = $(".add-to-machine a[data-machine-id='" + machine_id + "'] .machine-check");

          if (playlist_ids.includes(playlist_id)) {
            check.removeClass("invisible");
          }

        }
      }
    })
  }

})(window, jQuery)

