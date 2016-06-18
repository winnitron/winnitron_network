(function(window, $, undefined){

  $(function() {
    $("#s3-uploader").S3Uploader();

    $("#s3-uploader").bind("s3_upload_complete", function(e, content) {
      $(".js-upload-status").html("Uploading " + content.filename + " complete!");
      $(".js-upload-status").css("visibility", "visible");
      $("pre.js-filename").html(content.filename);
    });
  });

})(window, jQuery)