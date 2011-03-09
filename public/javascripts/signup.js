var geocoder = null;

$(document).ready(function(){
	geocoder = new google.maps.Geocoder();

	$('#username').keyup(function(){
		check_unique_username($(this));
	});

	$('#username').blur(function(){
		if(validate_username($(this).val())){
			check_unique_username($(this));
		}
	});

	$('#password').password_strength({
		container: '#password_messages',
		minLength: 6
	});

	$('#password').blur(function(){
		validate_password($("#password").val());
	});

	$('#password_confirmation').blur(function(){
		validate_passwords_match($("#password").val(), $("#password_confirmation").val());
	});

	$('#zip_code').blur(function(){
		if(validate_zip($("#zip_code").val())){
			getCity($("#zip_code").val());
		}
	});

	$('#email').blur(function(){
		validate_email($("#email").val());
	});

	$('form.signup').submit(function(){
		var $isValid = true;
		if(!validate_email($("#email").val())){
			$("#email").focus();
			$("#email").select();
			$isValid = false;
		}
		if(!validate_zip($("#zip_code").val())){
			$('#zip_code').focus();
			$('#zip_code').select();
			$isValid = false;
		}
		if(!validate_passwords_match($("#password").val(), $("#password_confirmation").val())){
			$('#password_confirmation').focus();
			$('#password_confirmation').select();
			$isValid = false;
		}
		if(!validate_password($("#password").val())){
			$("#password").focus();
			$("#password").select();
			$isValid = false;
		}
		if(!validate_username($("#username").val())){
			$("#username").focus();
			$("#username").select();
			$isValid = false;
		}
		return $isValid;
	});


});

function validate_password(password){
	if(password.length < 6){
		$('#password_messages').html("Password is too short.");
		$("#password_messages").removeClass();
		return false;
	}
	return true;
}

function validate_zip(zip){
	if(!zip.match(/^\d{5}$/)){
		$('#zip_code_messages').html("Invalid zip code.");
		return false;
	}
	return true;
}

function validate_email(email) {
  return true;

	var reg = /^([A-Za-z0-9_\-\.])+\@([A-Za-z0-9_\-\.])+\.([A-Za-z]{2,4})$/;
	if(reg.test(email) == false) {
		$("#email_message").html('Invalid email address');
		return false;
	}
	$("#email_message").html('');
	return true;
}


function getCity(zipcode) {
	geocoder.geocode( {
		'address': zipcode
	}, function (result, status) {
		var state = "N/A";
		for (var component in result[0]['address_components']) {
			for (var i in result[0]['address_components'][component]['types']) {
				//if (result[0]['address_components'][component]['types'][i] == "administrative_area_level_1") {
				if (result[0]['address_components'][component]['types'][i] == "locality") {
					city = result[0]['address_components'][component]['short_name'];
					// do stuff with the state here!
					$('#zip_code_messages').html("Zip code is in " + city + ".");
					return;
				}
			}
		}
	});
}

function validate_passwords_match(password, retype_password)
{
	$("#password_messages").removeClass();
	if(validate_password(password)){
		if(password != retype_password){
			$('#password_messages').html("Passwords do not match.");
			return false;
		}
	}
	else{
		return false;
	}
	$('#password_messages').html("");
	return true;
}

function validate_username(username) {
	if(username.length < 4){
		$('#username_messages').html("Username must be at least four characters long.");
		return false;
	}
	return true;
}

function check_unique_username(element){
	if(element.val().length > 3){
		username = element.val();
		$.ajax({
			url: '/services/check_unique_user',
			dataType: 'json',
			type: 'post',
			data: "username=" + username,
			beforeSend: function(){
				$('#username_messages').html("Checking if username is already taken.");
			},
			success: function(data){
				var $current_username = $("#username").val();
				var $checked_username = data['username'];
				if($current_username == $checked_username)
					if(data['unique']){
						$('#username_messages').html($checked_username + " is unique.");
					}
					else{
						$('#username_messages').html($checked_username + " is already taken.  Try a different name.");
					}
				else {
					$('#username_messages').html("");
				}
			},
			error: function(XMLHttpRequest, textStatus, errorThrown){
				$('#username_messages').html("Error encountered when checking username");
			}

		});
	}
}

