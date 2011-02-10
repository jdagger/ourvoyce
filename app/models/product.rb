class Product < ActiveRecord::Base
  has_many :product_supports
  has_many :users, :through => :product_supports
  has_many :product_audits

  class << self
    def upc_lookup(options = {})
      raise "UPC not specified" if options[:upc].nil?
      Product.where("upc = ? OR ean = ?", options[:upc], options[:upc])
    end


    # text - search text
    # user_id - user id, if support should be included
    #   vote - if user_id is specified, will filter by thumbs_up, thumbs_down, vote, no_vote, all
    # sort_name
    # sort_direction
    # do_search will return an AR object with all that match the specified filter.  
    # It DOES NOT apply paging (limit, offset)
    def do_search(params={})
      records = Product.where('1=1')
      select = ['products.id as id', 'products.name as name', 'products.logo as logo', 'products.social_score as social_score', 'products.participation_rate as participation_rate', 'products.pending', 'products.description', 'products.upc']

      #If the user_id is specified, load the vote data
      if params.key? :user_id
        select << 'product_supports.support_type as support_type'
        records = records.joins("LEFT OUTER JOIN product_supports ON products.id=product_supports.product_id AND user_id=#{params[:user_id].to_i}")
      end

      #Only apply text filter or thumbs up/thumbs down filter
      #if params.key? :text
        #Get a list of product ids that match the search text
      #  records_to_include = Product.search params[:text].strip
      #  product_ids = records_to_include.inject([]) do |r, element|
      #    r << element.id
      #    r
      #  end
      #  records = records.where("products.id in (?)", product_ids)
      #elsif params.key? :vote
      if params.key? :vote
        case params[:vote].strip.upcase
        when "THUMBSUP"
          records = records.where("support_type = 1")
        when "THUMBSDOWN"
          records = records.where("support_type = 0")
        when "NEUTRAL"
          records = records.where("support_type = 2")
        when "VOTED"
          records = records.where("support_type >= 0")
        when "NOVOTE"
          records = records.where("support_type = -1")
        when "ALL"
          records = records
        end
      else
          records = records.where("support_type >= -1")
      end

      if params.key? :social_score
        records = records.where("social_score >= ?", params[:social_score].to_i)
      end

      if params.key? :participation_rate
        records = records.where("participation_rate >= ?", params[:participation_rate].to_i)
      end

      records = records.select(select.join(", "))

      if params.key?(:sort_direction) && params.key?(:sort_name)
        begin
          column = params[:sort_name].downcase
          direction = params[:sort_direction].downcase

          direction = (direction == 'asc') ? 'asc' : 'desc'

          case column
          when ('name' || 'description')
            column = 'products.description'
          when 'social'
            column = 'products.social_score'
          when 'participation'
            column = 'products.participation_rate'
          when 'votedate'
            if params.key? :user_id
              column = 'product_supports.updated_at'
            end
          when 'profit'
            column = 'products.profit'
          when 'revenue'
            column = 'products.revenue'
          else
            column = 'products.description'
          end

          records = records.order("#{column} #{direction}")
        rescue
        end
      end

      return records
    end
  end
end
