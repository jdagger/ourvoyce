class RequestFactory
	attr_accessor :request

	def initialize(request)
		self.request = request
	end

	def create_instance
		case request.method
		when "Authenticate"
			return AuthenticateHandler.new self.request
		when "Logout"
			return LogoutHandler.new self.request
		when "BarcodeLookup"
			return ProductLookupHandler.new self.request
		when "ProductVote"
			return ProductVoteHandler.new self.request
		when "ProductSearch"
			return ProductSearchHandler.new self.request
		when "CreateProduct"
			return CreateProductHandler.new self.request
		when "CorporateSearch"
			return CorporationSearchHandler.new self.request
		when "CorporationVote"
			return CorporationVoteHandler.new self.request
		when "CorporationLookup"
			return CorporationLookupHandler.new self.request
		when "GovernmentSearch"
			return GovernmentSearchHandler.new self.request
		when "GovernmentVote"
			return GovernmentVoteHandler.new self.request
		when "GovernmentLookup"
			return GovernmentLookupHandler.new self.request
		when "MediaSearch"
			return MediaSearchHandler.new self.request
		when "MediaVote"
			return MediaVoteHandler.new self.request
		when "MediaLookup"
			return MediaLookupHandler.new self.request
		when "MyVoyceStats"
			return MyvoyceStatsHandler.new self.request
		when "GovernmentSummary"
			return GovernmentSummaryHandler.new self.request
		when "MediaSummary"
			return MediaSummaryHandler.new self.request
		when "MediaState"
			return MediaStateHandler.new self.request
		when "LegislativeStates"
			return LegislativeStateHandler.new self.request
    when "MediaTypes"
      return MediaTypesHandler.new self.request
    when "GovernmentTypes"
      return GovernmentTypesHandler.new self.request
    when "ReportError"
      return ErrorReportingHandler.new self.request
		else
			return nil
		end
	end
end
