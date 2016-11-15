(function(window, $, undefined) {
  $(function() {
    $(".collapse-arrow").click(function (e) {
      e.preventDefault();
      $(this).siblings(".the-games").toggle("fast");
      $(this).siblings(".the-playlists").toggle("fast");

      if ($(this).html() == "►")
        $(this).html("▼")
      else
        $(this).html("►")

    });


    $("#image-uploader").bind("s3_upload_complete", function(e, content) {
      img = '<img src="' + content.url + '">';
      link = '<a href="' + content.url + '" class="screenshot">' + img + '</a>';
      $(".current-images").append(link)
    })
  });

})(window, jQuery)