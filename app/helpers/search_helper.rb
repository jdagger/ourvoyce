module SearchHelper
	attr_accessor :search_options
	attr_accessor :search_object

	def get_search_results
		offset = self.search_options[:offset] || 0
		limit = self.search_options[:limit] || 20
		self.search_object.limit(limit).offset(offset)
	end

	def get_search_total_records
		self.search_object.count
	end

	def build_search options = {}
		self.search_options = options
		initialize_search_instance
		#Add the select list
		if self.search_options[:select]
			self.search_object = self.search_object.select(self.search_options[:select].join(","))
		end

		apply_common_sorting
		if defined? apply_custom_sorting
			apply_custom_sorting
		end

		apply_common_filters
		if defined? apply_custom_filters
			apply_custom_filters
		end


	end

	def apply_common_filters
		if !self.search_options[:filters].nil?
			filters = self.search_options[:filters]
			filters.each do |key, value|
				case key
				when :vote #Apply vote filter
					case value.to_s.upcase
					when "THUMBSUP"
						self.search_object = self.search_object.where("support_type = 1")
					when "THUMBSDOWN"
						self.search_object = self.search_object.where("support_type = 0")
					when "NEUTRAL"
						self.search_object = self.search_object.where("support_type = 2")
					when "VOTED"
						#self.search_object = self.search_object.where("support_type IS NOT NULL")
            self.search_object = self.search_object.where("support_type >= 0")
					when "NOVOTE"
            self.search_object = self.search_object.where("support_type IS NULL OR support_type = -1")
          when "LIMITEDNOVOTE"
						self.search_object = self.search_object.where("support_type = -1")
					end
				when :participation_rate
					self.search_object = self.search_object.where("participation_rate >= ?", value)
				when :social_score
					self.search_object = self.search_object.where("social_score >= ?", value)
				when :text
					#value = "%#{value}%"
					#self.search_object = self.search_object.where("name like ?", value)
          self.search_object = self.search_object.search value

				end
			end
		end
	end

	#Optional params:
	# - default_sort_order
	# - default_sort_direction
	# - name_column
	# - vote_date_column
	def apply_common_sorting
		sorting_options = self.search_options[:sorting]

		sort_direction = sorting_options[:sort_direction] ? sorting_options[:sort_direction].upcase : ''
		sort_name = sorting_options[:sort_name] ? sorting_options[:sort_name].upcase : ''

		case sort_direction
		when "DESC"
			sort_direction = "DESC"
		when "ASC"
			sort_direction = "ASC"
		else
			if sorting_options[:default_sort_direction]
				sort_direction = sorting_options[:default_sort_direction]
			else
				sort_direction = "ASC"
			end
		end

		case sort_name.upcase
		when "SOCIAL"
			sort_name = "social_score"
		when "PARTICIPATION"
			sort_name = "participation_rate"
		when "PROFIT"
			sort_name = "profit"
		when "REVENUE"
			sort_name = "revenue"
		when "VOTEDATE"
			if(sorting_options[:vote_date_column])
				sort_name = sorting_options[:vote_date_column]
			else
				sort_name = "updated_at"
			end
		when "NAME"
			if(sorting_options[:name_column])
				sort_name = sorting_options[:name_column]
			else
				sort_name = "name"
			end
		else
			if(sorting_options[:default_sort_order])
				sort_name = sorting_options[:default_sort_order]
			else
				sort_name ="name"
			end
		end

		self.search_object = self.search_object.order("#{sort_name} #{sort_direction}")
	end
end
