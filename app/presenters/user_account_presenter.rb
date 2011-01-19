class UserAccountPresenter #< Presenter
	attr_accessor :username
	attr_accessor :password
	attr_accessor :retype_password
	attr_accessor :zip_code
	attr_accessor :birth_year
	attr_accessor :gender
	attr_accessor :email
	attr_accessor :retype_email


	def initialize(values = nil)
		if(values != nil)
			@username = values[:username] || ''
			@password = values[:password] || ''
			@retype_password = values[:retype_password] || ''
			@zip_code = values[:zip_code] || ''
			@birth_year = values[:birth_year] || ''
			@gender = values[:gender] || ''
			@email = values[:email] || ''
			@retype_email = values[:retype_email] || ''
		end
	end

	def save
		user = User.new(:username => @username, :password => @password, :birth_year => @birth_year, :gender => @gender, :zip_code => @zip_code, :email => @email)
		user.save
	end

end
