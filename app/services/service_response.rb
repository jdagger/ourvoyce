class ServiceResponse

	attr_accessor :status
	attr_accessor :message
	attr_accessor :handler_base

	def initialize(handler_base)
		self.handler_base = handler_base
		self.status = '100';
		self.message = '';
	end

	def populate_result
		#All the response class to populate it's portion
		result_hash = {"Header" => {}, "Body" => {}}
		header = result_hash["Header"]
		header["Status"] = self.status
		header["Message"] = self.message
		header["QueryId"] = self.handler_base.request.query_id

		self.handler_base.populate_result(result_hash)
		return result_hash
	end
end
