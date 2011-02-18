require 'digest/sha2'
require 'email_validator'

class User < ActiveRecord::Base
  include AgeGraphHelper
  include MapGraphHelper

  validates_presence_of :username, :message => "Username is required"
  validates_length_of :username, :minimum => 4, :maximum => 10, :too_short => "Username must be at least four characters long", :too_long => "Username must have 10 or fewer characters"
  validates_uniqueness_of :username, :message => "Username already taken"

  validates_length_of :password, :minimum => 6, :maximum => 20, :message => "Password must have between 6 and 20 characters"
  validate :password_must_be_present
  validates_confirmation_of :password, :message => "Passwords do not match"

  validates_numericality_of :zip_code, :message => "Zip code must be a number"
  validates_length_of :zip_code, :is => 5, :message => "Invalid zip code length"

  validates_numericality_of :birth_year, :message => "Year of birth must be a number"
  validates_format_of  :birth_year, :with => /^(19|20)\d{2}$/ , :message => "Invalid year"

  validates_presence_of :email, :message => "Email is required"
  validates_length_of :email, :minimum => 5, :maximum => 80, :message => "Invalid email length"
  validates :email, :email => true

  attr_accessor :password_confirmation
  attr_reader :password


  has_many :product_supports
  has_many :product_scans
  has_many :products, :through => :product_supports
  has_many :product_audits

  has_many :corporation_supports
  has_many :corporations, :through => :corporation_supports
  has_many :corporation_audits

  has_many :media_supports
  has_many :medias, :through => :media_supports
  has_many :media_audits

  has_many :government_supports
  has_many :governments, :through => :government_supports
  has_many :government_audits

  def user_stats user_id
    user = User.find user_id

    {
		  :member_since => user.created_at.strftime("%B %d, %Y"),
		  :username => user.username,
		  :total_scans => ProductScan.where(:user_id => user.id).count,
      :today_scans => ProductScan.where("user_id = ? AND updated_at > ?", user.id, Time.now.beginning_of_day).count,
      :this_week_scans => ProductScan.where("user_id = ? AND updated_at > ?", user.id, Time.now.beginning_of_week).count,
      :this_month_scans => ProductScan.where("user_id = ? AND updated_at > ?", user.id, Time.now.beginning_of_month).count,
      :this_year_scans => ProductScan.where("user_id = ? AND updated_at > ?", user.id, Time.now.beginning_of_year).count
    }
  end


  def age_all 
    init_age_stats
    User.find(:all, :group => 'birth_year', :select => 'birth_year, count(birth_year) as count').each do |user|
      add_age_hash_entry :age => Time.now.year - user.birth_year.to_i, :support_type => -1, :count => user.count.to_i
    end

    max_total_element = self.age_stats.values.max { |a, b| a[:count].to_i <=> b[:count].to_i }
    self.age_max_total = max_total_element[:count]

    self.age_stats.each do |key, value|
      self.age_data << {:label => key, :color => "00ff00", :scale => value[:count].to_f / self.age_max_total, :total => value.count }
    end


    return {:ages => self.age_data, :max => self.age_max_total}
  end

  def age_state state
    state = state.upcase

    users = User.find(
      :all, 
      :conditions => {"states.abbreviation" => state}, 
      :joins => [
        'join zips on users.zip_code = zips.zip', 
        'join states on zips.state_id = states.id'
    ],
      :select => 'birth_year, count(birth_year) as count',
      :group => 'birth_year')

    init_age_stats

    users.each do |user|
      add_age_hash_entry :age => Time.now.year - user.birth_year.to_i, :support_type => -1, :count => user.count.to_i
    end

    max_total_element = self.age_stats.values.max { |a, b| a[:count].to_i <=> b[:count].to_i }
    self.age_max_total = max_total_element[:count]

    self.age_stats.each do |key, value|
      self.age_data << {:label => key, :color => "00ff00", :scale => value[:count].to_f / self.age_max_total, :total => value.count }
    end

    return {:ages => self.age_data, :max => self.age_max_total}
  end

  def map_all
    init_national_map_stats

    users = User.find( 
                      :all, 
                      :joins => [ 
                        "join zips on users.zip_code = zips.zip", 
                        "join states on zips.state_id = states.id" 
    ], 
      :select => "states.abbreviation as abbreviation, count(states.abbreviation) as count, states.population as population", 
      :group => "states.abbreviation, states.population") 

    stats = []
    #collect the data
    users.each do |user|
      stats << { :state => user[:abbreviation], :percent => user[:count].to_f * 100.0 / user[:population].to_f }
    end

    max_percent = stats.max { |a, b| a[:percent].to_f <=> b[:percent].to_f }

    #normalize the data
    stats.each do |stat|
      scale = (stat[:percent] * 100 / max_percent[:percent]).to_i
      self.national_map_stats << { :name => stat[:state], :color => shades_of_green(scale) }
    end

    return self.national_map_stats
  end

  def map_state state
    state = state.upcase

    users = User.find(:all,
                      :select => "count(zips.zip) as count, zips.zip, zips.latitude, zips.longitude",
                      :joins => [
                        "join zips on users.zip_code = zips.zip", 
                        "join states on zips.state_id = states.id"
                      ],
                      :conditions => {"states.abbreviation" => state},
                      :group => "zips.zip, zips.latitude, zips.longitude")
    init_state_map_stats
    users.each do |c|
      add_state_map_element :zip => c.zip, :lat => c.latitude, :long => c.longitude, :support_type => -1, :count => c.count.to_i
    end

    max_count_element = self.state_map_collected_data.values.max{ |a, b| a[:count] <=> b[:count] }
    max_count = max_count_element[:count]


    self.state_map_collected_data.each do |key, value|
      self.state_map_stats << {:name => key, :color => '00ff00', :scale => value[:count].to_f / max_count, :lat => value[:lat], :long => value[:long], :votes => value[:count] }
    end
    (self.state_map_stats.sort! { |a, b| a[:scale] <=> b[:scale] }).reverse!

    return self.state_map_stats
  end

  class << self
    def authenticate(username, password)
      if user = find_by_username(username)
        if user.hashed_password == encrypt_password(password, user.salt)
          user
        end
      end
    end

    def encrypt_password(password, salt)
      Digest::SHA2.hexdigest(password + "#8jz_Fz" + salt)
    end
  end

  def password=(password)
    @password = password

    if password.present?
      generate_salt
      self.hashed_password = self.class.encrypt_password(password, salt)
    end
  end

  private
  def password_must_be_present
    errors.add(:password, "Password is required") unless hashed_password.present?
  end

  def generate_salt
    self.salt = self.object_id.to_s + rand.to_s
  end
end
