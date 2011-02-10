module MapGraphHelper
  attr_accessor :national_map_collected_data
  attr_accessor :national_map_stats

  attr_accessor :state_map_collected_data
  attr_accessor :state_map_stats

  attr_accessor :state_max_total_votes

  def init_national_map_stats
    self.national_map_collected_data = {}
    self.national_map_stats = []
  end


  def add_national_map_element params
    if ! self.national_map_collected_data.key? params[:abbreviation]
      self.national_map_collected_data[params[:abbreviation]] = {:negative => 0, :neutral => 0, :positive => 0}
    end

    element = self.national_map_collected_data[params[:abbreviation]]

    record_support_type element, params[:support_type], params[:count]
  end

  def calculate_national_map_stats
    self.national_map_collected_data.each do |key, value|
      #Find total number of votes
      negative = self.national_map_collected_data[key][:negative].to_i
      positive = self.national_map_collected_data[key][:positive].to_i
      neutral = self.national_map_collected_data[key][:neutral].to_i
      total = negative + neutral + positive

      #determine a score
      score = (negative * -1 + positive).to_f / total
      self.national_map_stats << {:name => key, :color => calculated_color(score)}
    end
  end



  def init_state_map_stats
    self.state_map_collected_data = {}
    self.state_map_stats = []
    self.state_max_total_votes = 0
  end


  def add_state_map_element params
    if ! self.state_map_collected_data.key? params[:zip]
      self.state_map_collected_data[params[:zip]] = {:negative => 0, :neutral => 0, :positive => 0, :lat => params[:lat], :long => params[:long]}
    end

    element = self.state_map_collected_data[params[:zip]]

    record_support_type element, params[:support_type], params[:count]
  end



  def calculate_state_map_stats
    self.state_map_collected_data.each do |key, value|
      #Find total number of votes
      negative = self.state_map_collected_data[key][:negative].to_i
      positive = self.state_map_collected_data[key][:positive].to_i
      neutral = self.state_map_collected_data[key][:neutral].to_i
      total = negative + neutral + positive
      self.state_max_total_votes = [self.state_max_total_votes, total].max

      #determine a score
      score = (negative * -1 + positive).to_f / total
      self.state_map_stats << {:name => key, :color => calculated_color(score), :scale => '1.0', :lat => value[:lat], :long => value[:long], :votes => total }

      #Calculate the scale
      self.state_map_stats.each do |zip|
        zip[:scale] = zip[:votes].to_f / self.state_max_total_votes
      end

      (self.state_map_stats.sort! { |a, b| a[:scale] <=> b[:scale] }).reverse!

    end
  end


  def record_support_type element, support_type, count
    case support_type
    when 0
      element[:negative] = count
    when 1
      element[:positive] = count
    when 2
      element[:neutral] = count
    end
  end


  def calculated_color score
    if score < -0.25
      color = 'ff0000'
    elsif score > 0.25
      color = '00ff00'
    else
      color = 'ffff00'
    end
  end
end
