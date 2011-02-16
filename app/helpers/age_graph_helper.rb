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
        break
      end
    end

    if ! element.nil?
      element[:count] += params[:count]
      case params[:support_type]
      when 0
        element[:negative] = params[:count]
      when 1
        element[:positive] = params[:count]
      when 2
        element[:neutral] = params[:count]
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
      total = value[:count]

      self.age_max_total = [self.age_max_total, total].max

      #determine a score
      if params.key? :color #If overriding the color, use that color
        color = params[:color]
      elsif total > 0
        score = (positive * 100) / total
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
  end

end
