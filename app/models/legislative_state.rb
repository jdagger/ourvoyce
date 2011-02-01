class LegislativeState < ActiveRecord::Base
	include SearchHelper

  belongs_to :state

	def initialize_search_instance
		self.search_object = LegislativeState.where("1=1")

    self.search_options[:sorting][:default_sort_order] = self.search_options[:sorting][:default_sort_order] || 'name'
    self.search_options[:limit] = 60
		self.search_object = self.search_object.joins("JOIN states ON legislative_states.state_id=states.id")
	end
end
