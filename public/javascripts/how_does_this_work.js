$(document).ready(function(){
  $("#how-does-this-work > div").hide();

  $("#how-does-this-work > h3").click(function(){
    $("#" + $(this).attr("id") + "_description").toggle();
  });
});
