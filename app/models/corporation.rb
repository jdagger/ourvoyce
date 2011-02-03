class Corporation < ActiveRecord::Base
	include SearchHelper

	has_many :corporation_supports
	has_many :users, :through => :corporation_supports
	has_many :corporation_audits

	def initialize_search_instance
		self.search_object = Corporation.where("1=1")
		self.search_options[:sorting][:vote_date_column] = "corporation_supports.updated_at"

		if self.search_options[:include_user_support]
			self.search_options[:select] << "support_type"
			self.search_object = self.search_object.joins("LEFT OUTER JOIN corporation_supports ON corporations.id=corporation_supports.corporation_id AND user_id=#{self.search_options[:include_user_support].to_i}")
		end
	end


	class << self
		def corporation_lookup id
			begin
				return Corporation.find id
			rescue
				return nil
			end
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
