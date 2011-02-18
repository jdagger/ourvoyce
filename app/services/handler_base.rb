class HandlerBase
  include ParticipationRateHelper

	attr_accessor :status
	attr_accessor :request
	attr_accessor :user

	def user_token
		self.request.parameters['UserToken'] || nil
	end

	def initialize(request)
		self.request = request
		self.user = nil
	end

	def load_user
		begin
			#See if the token exists in the token table
			auth_user = AuthenticationToken.find(self.user_token)

			#load the user
			self.user = auth_user.user
			return true
		rescue
			return false
		end
	end

	def handle_request
	end

	def get_response
		response = ServiceResponse.new(self)
		result = response.populate_result
		result
	end

	def populate_result(result_hash)
		result_hash
	end
end
