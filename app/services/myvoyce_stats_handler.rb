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

	def handle_request
    super
		if(!load_user)
			self.status = 0
			return
		end

    stats = User.new.user_stats self.user.id

		self.member_since = stats[:member_since]
		self.username = self.user.login

		self.total_votes = stats[:total_scans]
		self.today_votes = stats[:today_scans]
		self.this_week_votes = stats[:this_week_scans]
		self.this_month_votes = stats[:this_month_scans]
		self.this_year_votes = stats[:this_year_scans]

		self.total_votes_image = "#{Rails.configuration.logos_domain}/images/corporate_logos/128_128/not_found.gif"
		self.today_votes_image = "#{Rails.configuration.logos_domain}/images/corporate_logos/128_128/not_found.gif"
		self.this_week_votes_image = "#{Rails.configuration.logos_domain}/images/corporate_logos/128_128/not_found.gif"
		self.this_month_votes_image = "#{Rails.configuration.logos_domain}/images/corporate_logos/128_128/not_found.gif"
		self.this_year_votes_image = "#{Rails.configuration.logos_domain}/images/corporate_logos/128_128/not_found.gif"

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
