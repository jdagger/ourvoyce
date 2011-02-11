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


  def age_all 
    init_age_stats
    User.find(:all, :group => 'birth_year', :select => 'birth_year, count(birth_year)').each do |user|
      add_age_hash_entry :age => Time.now.year - user.birth_year.to_i, :support_type => -1, :count => user.count.to_i
    end
    generate_age_data :color => '00ff00'

    return {:ages => self.age_data, :max => self.age_max_total}
  end

  def age_state state
    state = state.upcase

    #Optimize by having state_id in a lookup hash
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

    generate_age_data :color => '00ff00'
    return {:ages => self.age_data, :max => self.age_max_total}
  end

  def map_all
    users = User.find(
      :all, 
      :joins => [
        "join zips on users.zip_code = zips.zip", 
        "join states on zips.state_id = states.id" 
      ], 
      :select => "states.abbreviation, count(states.abbreviation) as count", 
      :group => "states.abbreviation")

    init_national_map_stats

    users.each do |user|
      add_national_map_element :abbreviation => user.abbreviation, :support_type => -1, :count => user.count.to_i
    end

    calculate_national_map_stats


    return self.national_map_stats
  end

  def map_state state
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
