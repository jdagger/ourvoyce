class ErrorReportingHandler < HandlerBase
	def handle_request
    begin
      super
      message = self.request.parameters['Message']

      ErrorLog.create :message => message, :source => 'iphone'
    rescue
    end
    self.status = 1
	end

	def populate_result(result_hash)
		result_hash["Body"] = {"Status" => self.status }
	end
end
