class AuthenticateHandler < HandlerBase
	attr_accessor :authentication_token

	def username
		self.request.parameters['Username']
	end

	def password
		self.request.parameters['Password']
	end

	def handle_request
    super
		#user = User.authenticate(self.username, self.password)
    user_session = UserSession.new(:login => self.username, :password => self.password)

    #if user.nil?
    if ! user_session.save
			self.status = 0
			self.authentication_token = ''
		else
			token = AuthenticationToken.new
      token.user_id = user_session.user.id
			#token.user_id = user.id
			token.persist = true
			token.save
			self.authentication_token = token.uuid
			self.status = 1
		end
	end

	def populate_result(result_hash)
		result_hash["Body"] = {"UserToken" => self.authentication_token, "Status" => self.status }
	end
end
