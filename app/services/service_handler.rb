class ServiceHandler

	def initialize
	end

	def handle_request (request)
		service_request = ServiceRequest.new
		service_request.parse request

		service_factory = RequestFactory.new(service_request)
		request_instance = service_factory.create_instance
		if !request_instance.nil?
			request_instance.handle_request
			return request_instance.get_response
		else
			return nil
		end
	end

end