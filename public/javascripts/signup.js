var username_field_accessor = ".account #user_login";
var password_field_accessor = ".account #user_password";
var password_confirmation_field_accessor = ".account #user_password_confirmation";
var zip_field_accessor = ".account #user_zip_code";
var birth_year_field_accessor = ".account #user_birth_year";
var country_field_accessor = ".account #user_country_id";
var email_field_accessor = ".account #user_email";
var agreed_field_accessor = ".account #user_agreed";
var username_min_length = 4;
var us_code = 242;


$(document).ready(function(){

  $(password_field_accessor).password_strength({
    container: password_field_accessor + '_messages',
    minLength: 6,
    texts: {1:'Very weak', 2:'Weak', 3:'Normal', 4:'Strong', 5:'Very Strong'}
  });

  $(agreed_field_accessor).change(function(){
    validate_agreed();
  });

  $(username_field_accessor).blur(function(){
    username = $(username_field_accessor).val();
    if(validate_username(username)){
      check_unique_username(username);
    }
  });

  $(country_field_accessor).change(function(){
    if($(country_field_accessor).val() == us_code){
      $(zip_field_accessor).attr("disabled", false);
    }
    else{
      $(zip_field_accessor).attr("disabled", true);
      set_message(zip_field_accessor, "");
      set_neutral_field(zip_field_accessor);
      $(zip_field_accessor).val('');
    }

  });


  $(password_field_accessor).blur(function(){
    validate_password($(password_field_accessor).val());
  });

  $(password_confirmation_field_accessor).blur(function(){
    validate_passwords_match($(password_field_accessor).val(), $(password_confirmation_field_accessor).val());
  });

  $(birth_year_field_accessor).blur(function(){
    validate_birth_year($(birth_year_field_accessor).val());
  });

  $(zip_field_accessor).blur(function(){
    zip = $(zip_field_accessor).val();
    if(validate_zip(zip)){
      server_validate_zip(zip);
    }
  });

  $(email_field_accessor).blur(function(){
    email = $(email_field_accessor).val();
    if(validate_email(email)){
      check_unique_email(email);
    }
  });

  $('form.account').submit(function(){
    var $isValid = true;
    if(!validate_agreed($(agreed_field_accessor).val())){
      $(agreed_field_accessor).focus();
      $(agreed_field_accessor).select();
      $isValid = false;
    }
    if(!validate_email($(email_field_accessor).val())){
      $(email_field_accessor).focus();
      $(email_field_accessor).select();
      $isValid = false;
    }
    if(!validate_birth_year($(birth_year_field_accessor).val())){
      $(birth_year_field_accessor).focus();
      $(birth_year_field_accessor).select();
      $isValid = false;
    }
    if(!validate_zip($(zip_field_accessor).val())){
      $(zip_field_accessor).focus();
      $(zip_field_accessor).select();
      $isValid = false;
    }
    if(!validate_passwords_match($(password_field_accessor).val(), $(password_confirmation_field_accessor).val())){
      $(password_confirmation_field_accessor).focus();
      $(password_confirmation_field_accessor).select();
      $isValid = false;
    }
    if(!validate_password($(password_field_accessor).val())){
      $(password_field_accessor).focus();
      $(password_field_accessor).select();
      $isValid = false;
    }
    if(!validate_username($(username_field_accessor).val())){
      $(username_field_accessor).focus();
      $(username_field_accessor).select();
      $isValid = false;
    }
    return $isValid;
  });
});

function validate_agreed(){
  if($(agreed_field_accessor + ":checked").length == 0){
    set_invalid_field(agreed_field_accessor);
    return false;
  }
  else{
    set_valid_field(agreed_field_accessor);
    return true;
  }
}

function validate_password(password){
  $(password_field_accessor + "_messages").removeClass();
  if(password.length < 6){
    set_invalid_field(password_field_accessor);
    set_message(password_field_accessor, "Password is too short.");
    return false;
  }
  set_message(password_field_accessor, "");
  set_valid_field(password_field_accessor);
  return true;
}

function validate_zip(zip){
  if($(country_field_accessor).val() == us_code) { //First, make sure in the US
    if(!zip.match(/^\d{5}$/)){
      set_invalid_field(zip_field_accessor);
      set_message(zip_field_accessor, "Invalid zip format.");
      return false;
    }
    //set_message(zip_field_accessor, "");
    //set_valid_field(zip_field_accessor);
    return true;
  }
  else{
    set_message(zip_field_accessor, "");
    set_neutral_field(zip_field_accessor);
    return true;
  }
}

function validate_email(email) {

  var reg = /^([A-Za-z0-9_\-\.])+\@([A-Za-z0-9_\-\.])+\.([A-Za-z]{2,4})$/;
  if(reg.test(email) == false) {
    set_message(email_field_accessor, "Invalid email address");
    set_invalid_field(email_field_accessor);
    return false;
  }
  //set_message(email_field_accessor, "");
  //set_valid_field(email_field_accessor);
  return true;
}


function validate_passwords_match(password, retype_password)
{
  if(password != retype_password){
    set_message(password_confirmation_field_accessor, "Passwords do not match.");
    set_invalid_field(password_confirmation_field_accessor);
    return false;
  }
  else{
    set_valid_field(password_confirmation_field_accessor);
    set_message(password_confirmation_field_accessor, '');
    return true;
  }
}

function validate_birth_year(birth_year) {
  now = new Date;
  year = now.getFullYear();
  if (year - birth_year < 16){
    set_message(birth_year_field_accessor, 'You must be at least 16 to use the site.');
    set_invalid_field(birth_year_field_accessor);
    return false;
  }
  set_message(birth_year_field_accessor, '');
  set_valid_field(birth_year_field_accessor);
  return true;
}

function validate_username(username) {
  if(username.length < username_min_length){
    set_message(username_field_accessor, "Username must be at least four characters long.");
    set_invalid_field(username_field_accessor);
    return false;
  }
  //set_message(username_field_accessor, "");
  //set_valid_field(username_field_accessor);
  return true;
}

function set_message(id, message){
  element = $(id + "_messages");

  //If messages don't match, hide old message and show new one
  if(element.html() != message){
    element.fadeOut(300, function(){
      element.html(message);
      element.fadeIn(500);
    });
  }
}

function remove_indicator(id, class, callback){
  if($(id + "_indicator").hasClass(class)){
    $(id + "_indicator").fadeOut(300, function(){
      $(id + "_indicator").removeClass(class);
      if(callback != null){
        callback();
      }
    });
  }
  else{
    if(callback != null){
      callback();
    }
  }
}

function add_indicator(id, class){
  if(! $(id + "_indicator").hasClass(class)){
    $(id + "_indicator").hide();
    $(id + "_indicator").addClass(class);
  }
  $(id + "_indicator").fadeIn(500);
}

function set_valid_field(id){
  remove_indicator(id, "invalid-indicator", function(){add_indicator(id, "valid-indicator"); });
}

function set_invalid_field(id){
  remove_indicator(id, "valid-indicator", function(){ add_indicator(id, "invalid-indicator"); });
}

function set_neutral_field(id){
  remove_indicator(id, "valid-indicator", function(){ remove_indicator(id, "invalid-indicator", null); });
}

function check_unique_username(username){
  $.ajax({
    url: '/services/check_unique_user',
  dataType: 'json',
  type: 'post',
  data: "username=" + username,
  beforeSend: function(){
    set_neutral_field(username_field_accessor);
  },
  success: function(data){
             var $current_username = $(username_field_accessor).val();
             var $checked_username = data['username'];
             if($current_username == $checked_username){
               if(data['unique']){
                 set_valid_field(username_field_accessor);
                 set_message(username_field_accessor, "");
               }
               else{
                 set_message(username_field_accessor, "Username is already taken.");
                 set_invalid_field(username_field_accessor);
               }
             }
           },
  error: function(XMLHttpRequest, textStatus, errorThrown){
           set_message(username_field_accessor, "Error encountered when checking username");
         }
  });
}

function check_unique_email(email){
  $.ajax({
    url: '/services/check_unique_email',
  dataType: 'json',
  type: 'post',
  data: "email=" + email,
  beforeSend: function(){
    set_neutral_field(email_field_accessor);
  },
  success: function(data){
             var $current_email = $(email_field_accessor).val();
             var $checked_email = data['email'];
             if($current_email == $checked_email){
               if(data['unique']){
                 set_valid_field(email_field_accessor);
                 set_message(email_field_accessor, "");
               }
               else{
                 set_message(email_field_accessor, "Email is already associated with an account.");
                 set_invalid_field(email_field_accessor);
               }
             }
           },
  error: function(XMLHttpRequest, textStatus, errorThrown){
           set_message(email_field_accessor, "Error encountered when checking email.");
         }
  });
}

function server_validate_zip(zip){
  $.ajax({
    url: '/services/validate_zip',
  dataType: 'json',
  type: 'post',
  data: "zip=" + zip,
  beforeSend: function(){
    set_neutral_field(zip_field_accessor);
  },
  success: function(data){
             var $current_zip = $(zip_field_accessor).val();
             var $checked_zip = data['zip'];
             if($current_zip == $checked_zip) {
               if(data['found']){
                 set_valid_field(zip_field_accessor);
                 set_message(zip_field_accessor, "");
               }
               else{
                 set_message(zip_field_accessor, "Zip could not be found.");
                 set_invalid_field(zip_field_accessor);
               }
             }
           },
  error: function(XMLHttpRequest, textStatus, errorThrown){
           set_message(zip_field_accessor, "Error encountered when validating zip");
         }
  });
}
