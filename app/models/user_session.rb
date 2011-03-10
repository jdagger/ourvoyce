class UserSession < Authlogic::Session::Base

  #Method needed as hack to get authlogic to work with rails 3
  #http://rorguide.blogspot.com/2011/02/getting-error-undefined-method-tokey.html
  #def to_key
    #new_record? ? nil : [ self.send(self.class.primary_key) ]
  #end
end
