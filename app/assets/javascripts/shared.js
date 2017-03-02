(function(window, $, undefined) {
  $(function() {
    $("#image-uploader").bind("s3_upload_complete", function(e, content) {
      img = '<img src="' + content.url + '">';
      link = '<a href="' + content.url + '">' + img + '</a></div>';
      $(".current-images").append(link)
    })
  });

})(window, jQuery)