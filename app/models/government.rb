class Government < ActiveRecord::Base
  include AgeGraphHelper
  include MapGraphHelper

  belongs_to :government_type
  has_many :government_supports
  has_many :users, :through => :government_supports
  has_many :government_audits
  belongs_to :state
  belongs_to :chamber

  #used by texticle to define indexes
  index do
    generated_indexes
  end

  def government_type_from_text text
    government_type_id = 0
    case text.downcase
    when 'agency'
      government_type_id = 1
    when 'executive'
      government_type_id = 2
    when 'legislative'
      government_type_id = 3
    end
    return government_type_id
  end

  def age_all branch, government_id
    government_type_id = government_type_from_text branch

    gov = GovernmentSupport.find(
      :all, 
      :conditions => {:government_id => government_id, "governments.government_type_id" => government_type_id}, 
      :joins => [
        "join users on users.id = government_supports.user_id",
        "join governments on governments.id = government_supports.government_id"
      ], 
      :select => "support_type, count(support_type) as count, users.birth_year", 
      :group => "support_type, users.birth_year"
    )

    init_age_stats 

    gov.each do |element|
      add_age_hash_entry :age => Time.now.year - element.birth_year.to_i, :support_type => element.support_type.to_i, :count => element.count.to_i
    end

    generate_age_data

    return {:ages => self.age_data, :max => self.age_max_total}
  end





  def age_state branch, government_id, state
    government_type_id = government_type_from_text branch
    state = state.upcase
    gov = GovernmentSupport.find(
      :all, 
      :conditions => {:government_id => government_id, "states.abbreviation" => state, "governments.government_type_id" => government_type_id }, 
      :joins => [
        "join users on users.id = government_supports.user_id",
        "join zips on users.zip_code = zips.zip",
        "join states on zips.state_id = states.id",
        "join governments on governments.id = government_supports.government_id"
      ], 
      :select => "support_type, count(support_type) as count, users.birth_year", 
      :group => "support_type, users.birth_year")

    init_age_stats

    gov.each do |element|
      add_age_hash_entry :age => Time.now.year - element.birth_year.to_i, :support_type => element.support_type.to_i, :count => element.count.to_i
    end

    generate_age_data

    return {:ages => self.age_data, :max => self.age_max_total}
  end

  def map_all branch, government_id
    government_type_id = government_type_from_text branch
    gov = GovernmentSupport.find(
      :all, 
      :conditions => {:government_id => government_id, "governments.government_type_id" => government_type_id}, 
      :joins => [
        "join users on users.id = government_supports.user_id",
        "join zips on users.zip_code = zips.zip",
        "join states on zips.state_id = states.id",
        "join governments on governments.id = government_supports.government_id"
      ], 
      :select => "support_type, count(support_type) as count, states.abbreviation as abbreviation", 
      :group => "support_type, states.abbreviation")

    #collect the results into a collection
    init_national_map_stats

    gov.each do |element|
      add_national_map_element :abbreviation => element.abbreviation, :support_type => element.support_type.to_i, :count => element.count.to_i
    end

    calculate_national_map_stats

    return self.national_map_stats
  end

  def map_state branch, government_id, state
    government_type_id = government_type_from_text branch
    state = state.upcase

    gov = GovernmentSupport.find(
      :all, 
      :conditions => {:government_id => government_id, "states.abbreviation" => state, "governments.government_type_id" => government_type_id}, 
      :joins => [
        "join governments on governments.id = government_supports.government_id",
        "join users on users.id = government_supports.user_id",
        "join zips on users.zip_code = zips.zip",
        "join states on zips.state_id = states.id"
      ], 
      :select => "support_type, count(support_type) as count, zips.zip, zips.latitude, zips.longitude", 
      :group => "support_type, zips.zip, zips.latitude, zips.longitude")

    init_state_map_stats
    #collect the results into a collection
    gov.each do |c|
      add_state_map_element :zip => c.zip, :lat => c.latitude, :long => c.longitude, :support_type => c.support_type.to_i, :count => c.count.to_i
    end

    calculate_state_map_stats
    return self.state_map_stats
  end



  class << self
    def government_lookup id
      begin
        return Government.find id
      rescue 
        return nil
      end
    end


    # text - search text
    # state - state id to include
    # branch - agency, executive, or legislative
    # user_id - user id, if support should be included
    #   vote - if user_id is specified, will filter by thumbs_up, thumbs_down, vote, no_vote, all
    # sort_name - name_desc, name_asc, default_asc, default_desc
    # do_search will return an AR object with all that match the specified filter.  
    # It DOES NOT apply paging (limit, offset)
    def do_search(params={})
      records = Government.where('1=1')
      select = ['governments.id as id', 'governments.name as name', 'governments.first_name as first_name', 'governments.last_name as last_name', 'governments.title as title', 'governments.office as office', 'governments.government_type_id as government_type_id', 'governments.chamber_id as chamber_id', 'governments.logo as logo', 'governments.social_score as social_score', 'governments.participation_rate as participation_rate', 'governments.district as district', 'governments.data1 as data1', 'governments.data2 as data2']

      #If the user_id is specified, load the vote data
      if params.key? :user_id
        select << 'government_supports.support_type as support_type'
        records = records.joins("LEFT OUTER JOIN government_supports ON governments.id=government_supports.government_id AND user_id=#{params[:user_id].to_i}")
      end

      #Only apply text filter or thumbs up/thumbs down filter
      if params.key? :text
        #Get a list of government ids that match the search text
        records_to_include = Government.search params[:text].strip
        government_ids = records_to_include.inject([]) do |r, element|
          r << element.id
          r
        end
        records = records.where("governments.id in (?)", government_ids)
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

      if params.key? :state
        records = records.where("state_id = ?", params[:state].to_i)
      end


      if params.key? :branch
        case params[:branch].downcase
        when "legislative"
          records = records.where("government_type_id = 3")
        when "executive"
          records = records.where("government_type_id = 2")
        when "agency"
          records = records.where("government_type_id = 1")
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
        sort = params[:sort].downcase
        case sort
        when 'name_asc'
            records = records.order('governments.name asc')
        when 'name_desc'
            records = records.order('governments.name desc')
        when 'social_asc'
            records = records.order('governments.social_score asc')
        when 'social_desc'
            records = records.order('governments.social_score desc')
        when 'participation_asc'
            records = records.order('governments.participation_rate asc')
        when 'participation_desc'
            records = records.order('governments.participation_rate desc')
        when 'votedate_asc'
          if params.key? :user_id
            records = records.order('government_supports.updated_at asc')
          end
        when 'votedate_desc'
          if params.key? :user_id
            records = records.order('government_supports.updated_at desc')
          end
        when 'default_asc'
          records = records.order('governments.default_order asc, governments.name asc')
        when 'default_desc'
          records = records.order('governments.default_order desc, governments.name asc')
        else
          records = records.order('governments.name asc')
        end
      end

      return records
    end
  end
end
