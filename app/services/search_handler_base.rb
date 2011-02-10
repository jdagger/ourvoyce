class SearchHandlerBase < HandlerBase
	attr_accessor :search_object
	attr_accessor :sort_direction
	attr_accessor :sort_name
	attr_accessor :total_records


	attr_accessor :search_instance
	attr_accessor :search_options

	def user_token
		self.request.parameters["UserToken"] || nil
	end

	def start_offset
		self.request.start_offset.to_i
	end

	def max_results
		self.request.max_results.to_i
	end

	def handle_request
		super

		if(load_user)
			search_options[:include_user_support] = self.user.id

			if self.request.filters["VOTE"]
				search_options[:filters][:vote] = self.request.filters["VOTE"]
			end
		end

		if self.request.filters["PARTICIPATIONRATE"]
			search_options[:filters][:participation_rate] = self.request.filters["PARTICIPATIONRATE"].to_i
		end

		if self.request.filters["SOCIALSCORE"]
			search_options[:filters][:social_score] = self.request.filters["SOCIALSCORE"].to_i
		end

		if self.request.filters["TEXT"]
			search_options[:filters][:text] = self.request.filters["TEXT"]

		end

		if self.request.filters["STATE"]
			search_options[:filters][:state] = self.request.filters["STATE"].to_i
		end

		if self.request.filters["GOVERNMENT_TYPE"]
			search_options[:filters][:government_type] = self.request.filters["GOVERNMENT_TYPE"]
		end

		if self.request.filters["PARENT_ID"]
			search_options[:parent_id] = self.request.filters["PARENT_ID"].to_i
		end

		if self.request.filters["MEDIA_TYPE"]
			search_options[:media_type] = self.request.filters["MEDIA_TYPE"].to_i
		end

		search_options[:sorting] = {:sort_name => self.request.sort_name, :sort_direction => self.request.sort_direction}
		search_options[:limit] = self.max_results
		search_options[:offset] = self.start_offset

		self.search_instance.build_search search_options

		self.total_records = self.search_instance.get_search_total_records #self.search_object.count
		self.search_object = self.search_instance.get_search_results

	end


	#Optional params:
	# - default_sort_order
	# - default_sort_direction
	# - name_column
	# - date_column
	def apply_sorting (options = {})
		#Apply sorting
		self.sort_direction = ''
		self.sort_name = ''

		case self.request.sort_direction.upcase
		when "DESC"
			self.sort_direction = "DESC"
		when "ASC"
			self.sort_direction = "ASC"
		else
			if(options.key?(:default_sort_direction))
				self.sort_direction = options[:default_sort_direction]
			else
				self.sort_direction = "ASC"
			end
		end

		case self.request.sort_name.upcase
		when "SOCIAL"
			self.sort_name = "social_score"
		when "PARTICIPATION"
			self.sort_name = "participation_rate"
		when "PROFIT"
			self.sort_name = "profit"
		when "REVENUE"
			self.sort_name = "revenue"
		when "VOTEDATE"
			if(options.key?(:date_column))
				self.sort_name = options[:date_column]
			else
				self.sort_name = "updated_at"
			end
		when "NAME"
			if(options.key?(:name_column))
				self.sort_name = options[:name_column]
			else
				self.sort_name = "name"
			end
		else
			if(options.key?(:default_sort_order))
				self.sort_name = options[:default_sort_order]
			else
				self.sort_name ="name"
			end
		end
	end

	# - text_field - name of text field to apply text filtering
	# - text_filter_type - starts_with for match beginning, default is contains
	def apply_filters (options = {})
		if(!self.request.filters.nil?)
			if(!self.request.filters["PARTICIPATIONRATE"].nil?)
				self.search_object = self.search_object.where("participation_rate >= ?", self.request.filters["PARTICIPATIONRATE"].to_i)
			end

			if(!self.request.filters["SOCIALSCORE"].nil?)
				self.search_object = self.search_object.where("social_score >= ?", self.request.filters["SOCIALSCORE"].to_i)
			end

			if(!self.request.filters["TEXT"].nil?)
				if(options.key?(:text_filter_type))
					case options[:text_filter_type]
					when 'starts_with'
						find_text = "#{self.request.filters["TEXT"]}%"
					else
						find_text = "%#{self.request.filters["TEXT"]}%"
					end
				else
					find_text = "%#{self.request.filters["TEXT"]}%"
				end
				if(options.key?(:text_field))
					self.search_object = self.search_object.where("#{options[:text_field]} like ?", find_text)
				else
					self.search_object = self.search_object.where("name like ?", find_text)
				end
			end

			if(!self.user.nil?)
				if(!self.request.filters["VOTE"].nil?)
					case self.request.filters["VOTE"].upcase
					when "THUMBSUP"
						self.search_object = self.search_object.where("support_type = 1")
					when "THUMBSDOWN"
						self.search_object = self.search_object.where("support_type = 0")
					when "NEUTRAL"
						self.search_object = self.search_object.where("support_type = 2")
					when "VOTED"
						self.search_object = self.search_object.where("support_type >= 0")
					when "NOVOTE"
						self.search_object = self.search_object.where("support_type is null")
          when "LIMITEDNOVOTE"
            self.search_object = self.search_object.where("support_type = -1")
					end
				end
			end
		end

		self.total_records = self.search_object.count
		self.search_object = self.search_object.limit(self.max_results).offset(self.start_offset)
		if(self.sort_name.length > 0)
			self.search_object = self.search_object.order("#{self.sort_name} #{self.sort_direction}")
		end
	end

	def populate_result(result_hash)
		super(result_hash)

		result_hash["Body"] = {}
		body = result_hash["Body"]
		body["Status"] = self.status

		body["TotalRecords"] = self.total_records
	end

end
