module AgeGraphHelper
  include ColorHelper

  attr_accessor :age_stats
  attr_accessor :age_data
  attr_accessor :age_max_total

  def age_lookups
    lookups = {}
    lookups['1-19'] = 0..19
    lookups['20-29'] = 20..29
    lookups['30-39'] = 30..39
    lookups['40-49'] = 40..49
    lookups['50-59'] = 50..59
    lookups['60-69'] = 60..69
    lookups['70-79'] = 70..79
    lookups['80+'] = 80..120
    lookups
  end

  def generate_age_all params

    [:base_object_name, :base_object_id].each do |required_element|
      if ! params.key? required_element
        throw "#{required_element} not specified"
      end
    end

    items = eval("#{params[:base_object_name].capitalize}Support")
    items = items.where("#{params[:base_object_name]}_id" => params[:base_object_id])
    items = items.where("#{params[:base_object_name]}_supports.support_type" => [0, 1])
    items = items.joins("join users on users.id = #{params[:base_object_name]}_supports.user_id")
    items = items.select("support_type, count(support_type) as count, users.birth_year")
    items = items.group("support_type, users.birth_year")

    if params.key? :joins
      params[:joins].each do |join|
        items = items.joins(join)
      end
    end

    if params.key? :conditions
      params[:conditions].each do |condition|
        items = items.where(condition)
      end
    end

    init_age_stats 

    items.each do |element|
      add_age_hash_entry :age => Time.now.year - element.birth_year.to_i, :support_type => element.support_type.to_i, :count => element.count.to_i
    end

    generate_age_data

    return {:ages => self.age_data, :max => self.age_max_total}
  end

  def generate_age_state params
    [:base_object_name, :base_object_id, :state].each do |required_element|
      if ! params.key? required_element
        throw "#{required_element} not specified"
      end
    end

    state = params[:state].upcase
    items = eval("#{params[:base_object_name].capitalize}Support")
    items = items.where("#{params[:base_object_name]}_id" => params[:base_object_id])
    items = items.where("#{params[:base_object_name]}_supports.support_type" => [0, 1])
    items = items.where("states.abbreviation" => state)
    items = items.joins("join users on users.id = #{params[:base_object_name]}_supports.user_id")
    items = items.joins("join zips on users.zip_code = zips.zip")
    items = items.joins("join states on zips.state_id = states.id")
    items = items.select("support_type, count(support_type) as count, users.birth_year")
    items = items.group("support_type, users.birth_year")

    init_age_stats

    items.each do |element|
      add_age_hash_entry :age => Time.now.year - element.birth_year.to_i, :support_type => element.support_type.to_i, :count => element.count.to_i
      #Rails.logger.error "Age: #{Time.now.year - element.birth_year.to_i}, Support Type: #{element.support_type.to_i}, Count: #{element.count.to_i}"
    end

    generate_age_data

    return {:ages => self.age_data, :max => self.age_max_total}
  end

  def init_age_stats
    self.age_stats = {}
    self.age_lookups.keys.each do |range|
      self.age_stats[range] = {:negative => 0, :neutral => 0, :positive => 0, :count => 0}
    end
  end

  def add_age_hash_entry params
    element = nil
    self.age_lookups.each do |key, range|
      if range === params[:age].to_i
        element = self.age_stats[key]
        #Rails.logger.error "Key: #{key}"
        break
      end
    end

    if ! element.nil?
      element[:count] += params[:count]
      case params[:support_type]
      when 0
        element[:negative] = element[:negative] + params[:count]
      when 1
        element[:positive] = element[:positive] + params[:count]
      when 2
        element[:neutral] = element[:neutral] + params[:count]
      end
    end
  end

  def generate_age_data params = {}
    self.age_data= []
    self.age_max_total = 0
    self.age_stats.each do |label, value|
      #Find total number of votes
      negative = value[:negative].to_i
      positive = value[:positive].to_i
      neutral = value[:neutral].to_i
      total = negative + positive

      self.age_max_total = [self.age_max_total, total].max

      #determine a score
      if params.key? :color #If overriding the color, use that color
        color = params[:color]
      elsif total > 0
        score = (positive * 100) / (negative + positive)
        color = color_from_social_score(score)
      else
        color = "ffffff"
      end
      self.age_data << {:label => label, :color => color, :scale => '1.0', :total => total}
    end

    self.age_data.sort! { |a, b| a[:label].to_i <=> b[:label].to_i }


    #set scale
    self.age_data.each do |age|
      age[:scale] = age[:total].to_f / self.age_max_total
    end

    self.age_data.each do |age|
      #Rails.logger.error "Label: #{age[:label]}, Color: #{age[:color]}, Scale: #{age[:scale]}, Total: #{age[:total]}"
   end

  end

end
