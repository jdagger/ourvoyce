$(document).ready(function(){
	$(".vote > thumbs-up").live("click", function(event){
		event.preventDefault();
		thumbs_up_clicked($(this));
	});

	$(".vote > .thumbs-up-not-selected").live("click", function(event){
		event.preventDefault();
		thumbs_up_clicked($(this));
	});

	$(".vote > .thumbs-up-selected").live("click", function(event){
		event.preventDefault();
	});

	$(".vote > .thumbs-down").live("click", function(event){
		event.preventDefault();
		thumbs_down_clicked($(this));
	});

	$(".vote > .thumbs-down-not-selected").live("click", function(event){
		event.preventDefault();
		thumbs_down_clicked($(this));
	});

	$(".vote > .thumbs-down-selected").live("click", function(event){
		event.preventDefault();
	});

	$(".vote > .neutral").live("click", function(event){
		event.preventDefault();
		neutral_clicked($(this));
	});

	$(".vote > .neutral-not-selected").live("click", function(event){
		event.preventDefault();
		neutral_clicked($(this));
	});

	$(".vote > .neutral-selected").live("click", function(event){
		event.preventDefault();
	});

	$(".vote > .clear-vote").live("click", function(event){
		event.preventDefault();
		clear_clicked($(this));
	});

});

function get_id(obj){
  return obj.siblings(':hidden').val();
}

function get_url(obj){
  return obj.parent().parent('form').attr('action');
}

function thumbs_up_clicked(obj){
	//Id of the selected item
	var $id = get_id(obj);
	var $url = get_url(obj);

	$.ajax({
		url: $url,
		dataType: 'json',
		type: 'post',
		data: "item_id=" + $id + "&thumbs_up=true",
		beforeSend: function(){
		},
		success: function(data){
			if(data["result"])
			{
				$('.jq-thumbs-down-' + $id).removeClass('thumbs-down').removeClass('thumbs-down-selected').addClass('thumbs-down-not-selected');
				$('.jq-thumbs-up-' + $id).removeClass('thumbs-up').removeClass('thumbs-up-not-selected').addClass('thumbs-up-selected');
				$('.jq-neutral-' + $id).removeClass('neutral').removeClass('neutral-selected').addClass('neutral-not-selected');
			}
		},
		error: function(XMLHttpRequest, textStatus, errorThrown){
			alert('Error encountered when recording vote.');
		}

	});
}

function thumbs_down_clicked(obj){
	//Id of the selected item
  $id = get_id(obj);
  $url = get_url(obj);

	$.ajax({
		url: $url,
		dataType: 'json',
		type: 'post',
		data: "item_id=" + $id + "&thumbs_down=true",
		beforeSend: function(){
		},
		success: function(data){
			if(data["result"])
			{
				$('.jq-thumbs-up-' + $id).removeClass('thumbs-up').removeClass('thumbs-up-selected').addClass('thumbs-up-not-selected');
				$('.jq-thumbs-down-' + $id).removeClass('thumbs-down').removeClass('thumbs-down-not-selected').addClass('thumbs-down-selected');
				$('.jq-neutral-' + $id).removeClass('neutral').removeClass('neutral-selected').addClass('neutral-not-selected');
			}
		},
		error: function(XMLHttpRequest, textStatus, errorThrown){
			alert('Error encountered when recording vote.');
		}

	});
}

function neutral_clicked(obj){
	//Id of the selected item
	var $id = get_id(obj);
	var $url = get_url(obj);

	$.ajax({
		url: $url,
		dataType: 'json',
		type: 'post',
		data: "item_id=" + $id + "&neutral=true",
		beforeSend: function(){
		},
		success: function(data){
			if(data["result"])
			{
				$('.jq-thumbs-down-' + $id).removeClass('thumbs-down').removeClass('thumbs-down-selected').addClass('thumbs-down-not-selected');
				$('.jq-thumbs-up-' + $id).removeClass('thumbs-up').removeClass('thumbs-up-selected').addClass('thumbs-up-not-selected');
				$('.jq-neutral-' + $id).removeClass('neutral').removeClass('neutral-not-selected').addClass('neutral-selected');
			}
		},
		error: function(XMLHttpRequest, textStatus, errorThrown){
			alert('Error encountered when recording vote.');
		}

	});
}

function clear_clicked(obj){
	//Id of the selected item
	var $id = get_id(obj);
	var $url = get_url(obj);

	$.ajax({
		url: $url,
		dataType: 'json',
		type: 'post',
		data: "item_id=" + $id + "&clear=true",
		beforeSend: function(){
		},
		success: function(data){
			if(data["result"])
			{
				$('.jq-thumbs-down-' + $id).removeClass('thumbs-down-not-selected').removeClass('thumbs-down-selected').addClass('thumbs-down');
				$('.jq-thumbs-up-' + $id).removeClass('thumbs-up-selected').removeClass('thumbs-up-not-selected').addClass('thumbs-up');
				$('.jq-neutral-' + $id).removeClass('neutral-not-selected').removeClass('neutral-selected').addClass('neutral');
			}
		},
		error: function(XMLHttpRequest, textStatus, errorThrown){
			alert('Error encountered when recording vote.');
		}

	});
}
