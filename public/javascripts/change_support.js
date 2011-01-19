$(document).ready(function(){
	$(".support-item-thumbs-up").live("click", function(event){
		event.preventDefault();
		thumbs_up_clicked($(this));
	});

	$(".support-item-thumbs-up-not-selected").live("click", function(event){
		event.preventDefault();
		thumbs_up_clicked($(this));
	});

	$(".support-item-thumbs-down").live("click", function(event){
		event.preventDefault();
		thumbs_down_clicked($(this));
	});

	$(".support-item-thumbs-down-not-selected").live("click", function(event){
		event.preventDefault();
		thumbs_down_clicked($(this));
	});

	$(".support-item-thumbs-up-selected").live("click", function(event){
		event.preventDefault();
	});

	$(".support-item-thumbs-down-selected").live("click", function(event){
		event.preventDefault();
	});

});

function thumbs_up_clicked(obj){
	//Id of the selected item
	var $id = obj.siblings(':hidden').val();
	var $url = obj.parent('form').attr('action');

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
				$('.thumbs-down-' + $id).removeClass('support-item-thumbs-down').removeClass('support-item-thumbs-down-selected').addClass('support-item-thumbs-down-not-selected');
				$('.thumbs-up-' + $id).removeClass('support-item-thumbs-up').removeClass('support-item-thumbs-up-not-selected').addClass('support-item-thumbs-up-selected');
				$('.support-item-header-' + $id).removeClass('support-item-header').removeClass('support-item-thumbs-down-header').addClass('support-item-thumbs-up-header');
			}
		},
		error: function(XMLHttpRequest, textStatus, errorThrown){
			alert('error experienced')
		}

	});
}

function thumbs_down_clicked(obj){
	//Id of the selected item
	var $id = obj.siblings(':hidden').val();

	var $url = obj.parent('form').attr('action');

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
				$('.thumbs-up-' + $id).removeClass('support-item-thumbs-up').removeClass('support-item-thumbs-up-selected').addClass('support-item-thumbs-up-not-selected');
				$('.thumbs-down-' + $id).removeClass('support-item-thumbs-down').removeClass('support-item-thumbs-down-not-selected').addClass('support-item-thumbs-down-selected');
				$('.support-item-header-' + $id).removeClass('support-item-header').removeClass('support-item-thumbs-up-header').addClass('support-item-thumbs-down-header');
			}
		},
		error: function(XMLHttpRequest, textStatus, errorThrown){
			alert('error experienced')
		}

	});
}