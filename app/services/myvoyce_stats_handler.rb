class MyvoyceStatsHandler < HandlerBase
	attr_accessor :username
	attr_accessor :total_votes
	attr_accessor :today_votes
	attr_accessor :this_week_votes
	attr_accessor :this_month_votes
	attr_accessor :this_year_votes

	attr_accessor :total_votes_image
	attr_accessor :today_votes_image
	attr_accessor :this_week_votes_image
	attr_accessor :this_month_votes_image
	attr_accessor :this_year_votes_image

	attr_accessor :member_since

	def handle_request(domain)
    super(domain)
		if(!load_user)
			self.status = 0
			return
		end

		self.total_votes = ProductSupport.where(:user_id => self.user.id).count
		#self.today_votes = 5
		self.today_votes = ProductSupport.where("user_id = ? AND updated_at > ?", self.user.id, Time.now.beginning_of_day).count
		self.this_week_votes = ProductSupport.where("user_id = ? AND updated_at > ?", self.user.id, Time.now.beginning_of_week).count
		self.this_month_votes = ProductSupport.where("user_id = ? AND updated_at > ?", self.user.id, Time.now.beginning_of_month).count
		self.this_year_votes = ProductSupport.where("user_id = ? AND updated_at > ?", self.user.id, Time.now.beginning_of_year).count

		self.total_votes_image = "http://#{self.domain}/images/corporate_logos/not_found_128_128.gif"
		self.today_votes_image = "http://#{self.domain}/images/corporate_logos/not_found_128_128.gif"
		self.this_week_votes_image = "http://#{self.domain}/images/corporate_logos/not_found_128_128.gif"
		self.this_month_votes_image = "http://#{self.domain}/images/corporate_logos/not_found_128_128.gif"
		self.this_year_votes_image = "http://#{self.domain}/images/corporate_logos/not_found_128_128.gif"

		self.member_since = self.user.created_at.strftime("%B %d, %Y")
		self.username = self.user.username
		self.status = 1
	end

	def populate_result(result_hash)
		result_hash["Body"] = { 
			"Username" => self.username,
			"TotalVotes" => self.total_votes,
			"TodayVotes" => self.today_votes,
			"ThisWeekVotes" => self.this_week_votes,
			"ThisMonthVotes" => self.this_month_votes,
			"ThisYearVotes" => self.this_year_votes,
			"TotalVotesImage" => self.total_votes_image,
			"TodayVotesImage" => self.today_votes_image,
			"ThisWeekVotesImage" => self.this_week_votes_image,
			"ThisMonthVotesImage" => self.this_month_votes_image,
			"ThisYearVotesImage" => self.this_year_votes_image,
			"MemberSince" => self.member_since,
			"Status" => self.status }
	end
end
