class Corporation < ActiveRecord::Base
  include AgeGraphHelper
  include MapGraphHelper

  has_many :corporation_supports
  has_many :users, :through => :corporation_supports
  has_many :corporation_audits

  #used by texticle to define indexes
  index do
    generated_indexes
  end

  def age_all corporation_id
    corp = CorporationSupport.find(:all, 
                                   :conditions => {:corporation_id => corporation_id}, 
                                   :joins => [
                                     "join users on users.id = corporation_supports.user_id"
    ], 
      :select => "support_type, count(support_type) as count, users.birth_year", 
      :group => "support_type, users.birth_year")

    init_age_stats 

    corp.each do |element|
      add_age_hash_entry :age => Time.now.year - element.birth_year.to_i, :support_type => element.support_type.to_i, :count => element.count.to_i
    end

    generate_age_data

    return {:ages => self.age_data, :max => self.age_max_total}
  end





  def age_state corporation_id, state
    state = state.upcase
    corp = CorporationSupport.find(:all, 
                                   :conditions => {:corporation_id => corporation_id, "states.abbreviation" => state }, 
                                   :joins => [
                                     "join users on users.id = corporation_supports.user_id",
                                     "join zips on users.zip_code = zips.zip",
                                     "join states on zips.state_id = states.id"
    ], 
      :select => "support_type, count(support_type) as count, users.birth_year", 
      :group => "support_type, users.birth_year")

    init_age_stats

    corp.each do |element|
      add_age_hash_entry :age => Time.now.year - element.birth_year.to_i, :support_type => element.support_type.to_i, :count => element.count.to_i
    end

    generate_age_data

    return {:ages => self.age_data, :max => self.age_max_total}
  end


  def map_state(corporation_id, state)
    state = state.upcase

    corp = CorporationSupport.find(:all, 
                                   :conditions => {:corporation_id => corporation_id, "states.abbreviation" => state}, 
                                   :joins => [
                                     "join users on users.id = corporation_supports.user_id",
                                     "join zips on users.zip_code = zips.zip",
                                     "join states on zips.state_id = states.id"
    ], 
      :select => "support_type, count(support_type) as count, zips.zip, zips.latitude, zips.longitude", 
      :group => "support_type, zips.zip, zips.latitude, zips.longitude")

    init_state_map_stats
    #collect the results into a collection
    corp.each do |c|
      add_state_map_element :zip => c.zip, :lat => c.latitude, :long => c.longitude, :support_type => c.support_type.to_i, :count => c.count.to_i
    end

    calculate_state_map_stats
  return self.state_map_stats

  end

  def map_all(corporation_id)
    corp = CorporationSupport.find(:all, 
                                   :conditions => {:corporation_id => corporation_id}, 
                                   :joins => [
                                     "join users on users.id = corporation_supports.user_id",
                                     "join zips on users.zip_code = zips.zip",
                                     "join states on zips.state_id = states.id"
    ], 
      :select => "support_type, count(support_type) as count, states.abbreviation as abbreviation", 
      :group => "support_type, states.abbreviation")
    #collect the results into a collection

    init_national_map_stats

    corp.each do |element|
      add_national_map_element :abbreviation => element.abbreviation, :support_type => element.support_type.to_i, :count => element.count.to_i
    end

    calculate_national_map_stats


    return self.national_map_stats
  end


  class << self
    def corporation_lookup id
      begin
        return Corporation.find id
      rescue
        return nil
      end
    end

    # text - search text
    # user_id - user id, if support should be included
    #   vote - if user_id is specified, will filter by thumbs_up, thumbs_down, vote, no_vote, all
    # sort
    # do_search will return an AR object with all that match the specified filter.  
    # It DOES NOT apply paging (limit, offset)
    def do_search(params={})
      records = Corporation.where('1=1')
      select = ['corporations.id as id', 'corporations.name as name', 'corporations.logo as logo', 'corporations.revenue as revenue', 'corporations.profit as profit', 'corporations.social_score as social_score', 'corporations.participation_rate as participation_rate']

      #If the user_id is specified, load the vote data
      if params.key? :user_id
        select << 'corporation_supports.support_type as support_type'
        records = records.joins("LEFT OUTER JOIN corporation_supports ON corporations.id=corporation_supports.corporation_id AND user_id=#{params[:user_id].to_i}")
      end

      #Only apply text filter or thumbs up/thumbs down filter
      if params.key? :text
        #Get a list of corporation ids that match the search text
        records_to_include = Corporation.search params[:text].strip
        corporate_ids = records_to_include.inject([]) do |r, element|
          r << element.id
          r
        end
        records = records.where("corporations.id in (?)", corporate_ids)
      elsif params.key? :vote
        case params[:vote].strip.upcase
        when "THUMBSUP"
          records = records.where("support_type = 1")
        when "THUMBSDOWN"
          records = records.where("support_type = 0")
        when "NEUTRAL"
          records = records.where("support_type = 2")
        when "VOTE"
          records = records.where("support_type >= 0")
        when "NOVOTE"
          records = records.where("support_type IS NULL OR support_type = -1")
        end
      end

      if params.key? :social_score
        records = records.where("social_score >= ?", params[:social_score].to_i)
      end

      if params.key? :participation_rate
        records = records.where("participation_rate >= ?", params[:participation_rate].to_i)
      end

      records = records.select(select.join(", "))

      if params.key? :sort
        begin
          #column, direction = params[:sort].downcase.split('_')
          #column = params[:sort_name].downcase
          #direction = params[:sort_direction].downcase

          #direction = (direction == 'asc') ? 'asc' : 'desc'

          #case column
          case params[:sort].downcase
          when 'name_asc'
            records = records.order('corporations.name asc')
          when 'name_desc'
            records = records.order('corporations.name desc')
          when 'social_asc'
            records = records.order('corporations.social_score asc')
          when 'social_desc'
            records = records.order('corporations.social_score desc')
          when 'participation_asc'
            records = records.order('corporations.participation_rate asc')
          when 'participation_desc'
            records = records.order('corporations.participation_rate desc')
          when 'votedate_asc'
            if params.key? :user_id
              records = records.order('corporation_supports.updated_at asc')
            end
          when 'votedate_desc'
            if params.key? :user_id
              records = records.order('corporation_supports.updated_at desc')
            end
          when 'profit_asc'
            records = records.order('corporations.profit asc')
          when 'profit_desc'
            records = records.order('corporations.profit desc')
          when 'revenue_asc'
            records = records.order('corporations.revenue asc')
          when 'revenue_desc'
            records = records.order('corporations.revenue desc')
          else
            records = records.order('corporations.name asc')
          end

          #records = records.order("#{column} #{direction}")
        rescue
        end
      end

      return records
    end
  end
end
