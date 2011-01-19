class SupportControlItem
	attr_accessor :id
	attr_accessor :name
	attr_accessor :logo
	attr_accessor :control

	def initialize values
		if !values.nil?
			self.id = values[:id] || 0
			self.name = values[:name] || ''
			self.logo = values[:logo] || ''
			self.control = values[:control] || nil
		end
	end
end

