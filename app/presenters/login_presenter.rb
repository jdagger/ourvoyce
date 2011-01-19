class LoginPresenter
	attr_accessor :username
	attr_accessor :password

	def initialize(values = {})
		self.username = values[:username] || ''
		self.password = values[:password] || ''
	end
end
