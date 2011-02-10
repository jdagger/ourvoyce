class Corporation < ActiveRecord::Base

  has_many :corporation_supports
  has_many :users, :through => :corporation_supports
  has_many :corporation_audits

  #used by texticle to define indexes
  index do
    generated_indexes
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
    # sort_name
    # sort_direction
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

      if params.key?(:sort_direction) && params.key?(:sort_name)
        begin
          #column, direction = params[:sort].downcase.split('_')
          column = params[:sort_name].downcase
          direction = params[:sort_direction].downcase

          direction = (direction == 'asc') ? 'asc' : 'desc'

          case column
          when 'name'
            column = 'corporations.name'
          when 'social'
            column = 'corporations.social_score'
          when 'participation'
            column = 'corporations.participation_rate'
          when 'votedate'
            if params.key? :user_id
              column = 'corporation_supports.updated_at'
            end
          when 'profit'
            column = 'corporations.profit'
          when 'revenue'
            column = 'corporations.revenue'
          else
            column = 'corporations.name'
          end

          records = records.order("#{column} #{direction}")
        rescue
        end
      end

      return records
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
      #collect the results into a collection
      result = corp.inject({}) { |r, element| 
        if ! r.key?(element.zip)
          r[element.zip] = {:negative => 0, :neutral => 0, :positive => 0, :lat => element.latitude, :long => element.longitude}
        end

        case element.support_type.to_i
        when 0
          r[element.zip][:negative] = element.count
        when 1
          r[element.zip][:positive] = element.count
        when 2
          r[element.zip][:neutral] = element.count
        end
        r
      }

      zips = [] 
      #total_votes = 0
      max_votes = 0
      result.each do |key, value|
        #Find total number of votes
        negative = result[key][:negative].to_i
        positive = result[key][:positive].to_i
        neutral = result[key][:neutral].to_i
        total = negative + neutral + positive

        #total_votes += total
        max_votes = [max_votes, total].max

        #determine a score
        score = (negative * -1 + positive).to_f / total
        color = 'ffffff'
        if score < -0.25
          color = 'ff0000'
        elsif score > 0.25
          color = '00ff00'
        else
          color = 'ffff00'
        end
        zips << {:name => key, :color => color, :scale => '1.0', :lat => value[:lat], :long => value[:long], :votes => total }
      end

      #Calculate the scale
      zips.each do |zip|
        zip[:scale] = zip[:votes].to_f / max_votes
      end

      (zips.sort! { |a, b| a[:scale] <=> b[:scale] }).reverse!

      return zips

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
      result = corp.inject({}) { |r, element| 
        if ! r.key?(element.abbreviation)
          r[element.abbreviation] = {:negative => 0, :neutral => 0, :positive => 0}
        end

        case element.support_type.to_i
        when 0
          r[element.abbreviation][:negative] = element.count
        when 1
          r[element.abbreviation][:positive] = element.count
        when 2
          r[element.abbreviation][:neutral] = element.count
        end
        r
      }

      states = [] 
      result.each do |key, value|
        #Find total number of votes
        negative = result[key][:negative].to_i
        positive = result[key][:positive].to_i
        neutral = result[key][:neutral].to_i
        total = negative + neutral + positive

        #determine a score
        score = (negative * -1 + positive).to_f / total
        color = 'ffffff'
        if score < -0.25
          color = 'ff0000'
        elsif score > 0.25
          color = '00ff00'
        else
          color = 'ffff00'
        end
        #states << {:name => key, :color => color, :negative => negative, :positive => positive, :neutral => neutral}
        states << {:name => key, :color => color}
      end

      return states
    end

    def age_all corporation_id
      corp = CorporationSupport.find(:all, 
                                     :conditions => {:corporation_id => corporation_id}, 
                                     :joins => [
                                       "join users on users.id = corporation_supports.user_id"
      ], 
        :select => "support_type, count(support_type) as count, users.birth_year", 
        :group => "support_type, users.birth_year")
      #collect the results into a collection

      #Initialize the collection
      result = (1..100).inject({}) { |r, element| 
        r["age_#{element}"] = {:negative => 0, :neutral => 0, :positive => 0}
        r
      }

      result = corp.inject(result) { |r, element| 
        age = Time.now.year - element.birth_year.to_i
        key = "age_#{age}"

        case element.support_type.to_i
        when 0
          r[key][:negative] = element.count
        when 1
          r[key][:positive] = element.count
        when 2
          r[key][:neutral] = element.count
        end
        r
      }

      ages = []
      max_total = 0
      result.each do |key, value|
        #Find total number of votes
        negative = result[key][:negative].to_i
        positive = result[key][:positive].to_i
        neutral = result[key][:neutral].to_i
        total = negative + neutral + positive

        max_total = [max_total, total].max

        #determine a score
        score = (negative * -1 + positive).to_f / total
        color = 'ffffff'
        if score < -0.25
          color = 'ff0000'
        elsif score > 0.25
          color = '00ff00'
        else
          color = 'ffff00'
        end
        ages << {:label => key.gsub("age_", ""), :color => color, :scale => '1.0', :total => total}
      end

      ages.sort! { |a, b| a[:label].to_i <=> b[:label].to_i }

      #set scale
      ages.each do |age|
        age[:scale] = age[:total].to_f / max_total
      end


      return {:ages => ages, :max => max_total}
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

      #Initialize the collection
      result = (1..100).inject({}) { |r, element| 
        r["age_#{element}"] = {:negative => 0, :neutral => 0, :positive => 0}
        r
      }

      #collect the results into a collection
      result = corp.inject(result) { |r, element| 
        age = Time.now.year - element.birth_year.to_i
        key = "age_#{age}"

        case element.support_type.to_i
        when 0
          r[key][:negative] = element.count
        when 1
          r[key][:positive] = element.count
        when 2
          r[key][:neutral] = element.count
        end
        r
      }

      ages = [] 
      max_total = 0
      result.each do |key, value|
        #Find total number of votes
        negative = result[key][:negative].to_i
        positive = result[key][:positive].to_i
        neutral = result[key][:neutral].to_i
        total = negative + neutral + positive

        max_total = [max_total, total].max

        #determine a score
        score = (negative * -1 + positive).to_f / total
        color = 'ffffff'
        if score < -0.25
          color = 'ff0000'
        elsif score > 0.25
          color = '00ff00'
        else
          color = 'ffff00'
        end
        ages << {:label => key.gsub("age_", ""), :color => color, :scale => '1.0', :total => total}
      end

      #set scale
      ages.each do |age|
        age[:scale] = age[:total].to_f / max_total
      end

      ages.sort! { |a, b| a[:label].to_i <=> b[:label].to_i }

      return {:ages => ages, :max => max_total}
    end

  end
end
