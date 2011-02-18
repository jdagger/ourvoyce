module MapGraphHelper
  include ColorHelper

  attr_accessor :national_map_collected_data
  attr_accessor :national_map_stats

  attr_accessor :state_map_collected_data
  attr_accessor :state_map_stats

  attr_accessor :state_max_total_votes

  def generate_map_all params
    [:base_object_name, :base_object_id].each do |required_element|
      if ! params.key? required_element
        throw "#{required_element} not specified"
      end
    end

    items = eval("#{params[:base_object_name].capitalize}Support")
    if ! params.key? :skip_object_id_filter || !params[:skip_object_id_filter]
      items = items.where("#{params[:base_object_name]}_id" => params[:base_object_id])
    end
    items = items.where("#{params[:base_object_name]}_supports.support_type" => [0, 1])
    items = items.joins("join users on users.id = #{params[:base_object_name]}_supports.user_id")
    items = items.joins("join zips on users.zip_code = zips.zip")
    items = items.joins("join states on zips.state_id = states.id")
    items = items.select("support_type, count(support_type) as count, states.abbreviation as abbreviation")
    items = items.group("support_type, states.abbreviation")

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

    #collect the results into a collection
    init_national_map_stats

    items.each do |element|
      add_national_map_element :abbreviation => element.abbreviation, :support_type => element.support_type.to_i, :count => element.count.to_i
    end

    calculate_national_map_stats params


    return self.national_map_stats
  end

  def generate_map_state params
    [:base_object_name, :base_object_id, :state].each do |required_element|
      if ! params.key? required_element
        throw "#{required_element} not specified"
      end
    end

    state = params[:state].upcase

    items = eval("#{params[:base_object_name].capitalize}Support")
    if !params.key? :skip_object_id_filter || !params[:skip_object_id_filter]
      items = items.where("#{params[:base_object_name]}_id" => params[:base_object_id])
    end
    items = items.where("#{params[:base_object_name]}_supports.support_type" => [0, 1])
    items = items.where("states.abbreviation" => state)
    items = items.joins("join users on users.id = #{params[:base_object_name]}_supports.user_id")
    items = items.joins("join zips on users.zip_code = zips.zip")
    items = items.joins("join states on zips.state_id = states.id")
    items = items.select("support_type, count(support_type) as count, zips.zip, zips.latitude, zips.longitude")
    items = items.group("support_type, zips.zip, zips.latitude, zips.longitude")

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

    init_state_map_stats
    #collect the results into a collection
    items.each do |c|
      add_state_map_element :zip => c.zip, :lat => c.latitude, :long => c.longitude, :support_type => c.support_type.to_i, :count => c.count.to_i
    end

    calculate_state_map_stats
    return self.state_map_stats

  end

  def init_national_map_stats
    self.national_map_collected_data = {}
    self.national_map_stats = []
  end


  def add_national_map_element params
    if ! self.national_map_collected_data.key? params[:abbreviation]
      self.national_map_collected_data[params[:abbreviation]] = {:negative => 0, :neutral => 0, :positive => 0, :count => 0}
    end

    element = self.national_map_collected_data[params[:abbreviation]]

    record_support_type element, params[:support_type], params[:count]
  end

  def calculate_national_map_stats params = {}
    self.national_map_collected_data.each do |key, value|
      #Find total number of votes
      negative = self.national_map_collected_data[key][:negative].to_i
      positive = self.national_map_collected_data[key][:positive].to_i
      neutral = self.national_map_collected_data[key][:neutral].to_i
      total = negative + positive

      #determine a score
      if total > 0
        score = positive * 100 / total
      else
        score = 0
      end

      if params.key? :color_method
        self.national_map_stats << { :name => key, :color => eval("#{params[:color_method]} #{score}") }
      else
        self.national_map_stats << { :name => key, :color => color_from_social_score(score) }
      end
    end
  end


  def init_state_map_stats
    self.state_map_collected_data = {}
    self.state_map_stats = []
    self.state_max_total_votes = 0
  end


  def add_state_map_element params
    if ! self.state_map_collected_data.key? params[:zip]
      self.state_map_collected_data[params[:zip]] = {:negative => 0, :neutral => 0, :positive => 0, :lat => params[:lat], :long => params[:long], :count => 0}
    end

    element = self.state_map_collected_data[params[:zip]]

    record_support_type element, params[:support_type], params[:count]
    #Rails.logger.error "ZIP: #{params[:zip]}, Support Type: #{params[:support_type]}, Count: #{params[:count]}"
  end



  def calculate_state_map_stats
    self.state_map_collected_data.each do |key, value|
      #Find total number of votes
      negative = self.state_map_collected_data[key][:negative].to_i
      positive = self.state_map_collected_data[key][:positive].to_i
      neutral = self.state_map_collected_data[key][:neutral].to_i
      total = negative + positive
      self.state_max_total_votes = [self.state_max_total_votes, total].max

      #determine a score
      if total > 0
        score = positive * 100 / total
      else
        score = 0
      end
      self.state_map_stats << {:name => key, :color => color_from_social_score(score), :scale => '1.0', :lat => value[:lat], :long => value[:long], :votes => total }

      #Calculate the scale
      self.state_map_stats.each do |zip|
        if self.state_max_total_votes > 0
          zip[:scale] = zip[:votes].to_f / self.state_max_total_votes
        else
          zip[:scale] = 0.0
        end
      end

      (self.state_map_stats.sort! { |a, b| a[:scale] <=> b[:scale] }).reverse!

    end
  end


  def record_support_type element, support_type, count
    element[:count] = element[:count] + count
    case support_type
    when 0
      element[:negative] = element[:negative] + count
    when 1
      element[:positive] = element[:positive] + count
    when 2
      element[:neutral] = element[:neutral] + count
    end
  end

end
