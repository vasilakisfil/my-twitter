function validateTweet() {
  if ($.trim($("#tweet-text").val())) {
    $("#tweet-btn2").prop("disabled", false)
  }
  else {
    $("#tweet-btn2").prop("disabled", true)
  }
}
$( document ).ready(function(){
  $("#tweet-text").bind("keyup", validateTweet )
});
