class ErrorReportingHandler < HandlerBase
	def handle_request
    begin
      super
      message = self.request.parameters['Message']
      request = self.request.parameters['Request']
      response = self.request.parameters['Response']
      device_type = self.request.parameters['DeviceType']
      user = self.request.parameters['User']

      ErrorLog.create :message => message, :request => request, :response => response, :device_type => device_type, :user => user,  :source => 'iphone'
    rescue
    end
    self.status = 1
	end

	def populate_result(result_hash)
		result_hash["Body"] = {"Status" => self.status }
	end
end
