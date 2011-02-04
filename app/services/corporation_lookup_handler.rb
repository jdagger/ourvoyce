class CorporationLookupHandler < LookupHandlerBase
	include ActionView::Helpers::NumberHelper
  include ImageHelper

	def corporation_id
		self.request.parameters['CorporationId']
	end

	def handle_request
    super
		self.item = Corporation.corporation_lookup(self.corporation_id)

		if self.item.nil?
			self.status = 0
			return
		end

		#product was found, so populate values
		self.status = 1

		#if user token was specified, try to find user support
		if load_user
			load_support(CorporationSupport.where("user_id = ? AND corporation_id = ?", self.user.id, self.item.id))
		end
	end

	def populate_result(result_hash)
		result_hash["Body"] = {}
		body = result_hash["Body"]

		body["Status"] = self.status

		#if product was found, return the name
		if(self.status != 0)
			body["CorporationId"] = self.item.id
			body["Name"] = self.item.name
      body["ImageUrl"] = get_corporate_image_128 self.item.logo
			body["Website"] = self.item.corporate_url
			body["Wikipedia"] = self.item.wikipedia_url
			body["Revenue"] = self.item.revenue_text
			body["Profit"] = self.item.profit_text
			#body["Revenue"] = "$" + number_to_human(self.item.revenue, :precision => 1, :significant => false)
			#body["Profit"] = "$" + number_to_human(self.item.profit, :precision => 1, :significant => false)
		end

		#if user token specified, return the support
		if(!self.user.nil?)
			body["UserSupport"] = self.user_support
		end
	end
end
