$(document).ready(function(){
  $('.jq-corporation').live('click', function(){
    $id = $(this).children('.jq-corporation-id').val();
    $url = "/services/website/corporate/" + $id + "/all";
    $.ajax({
      url: $url,
      dataType: 'xml',
      success: function(data){
        $('.jq-map').html("<textarea rows='50' cols='50'>" + (new XMLSerializer()).serializeToString(data) + "</textarea>");
      }
    });
  });
});