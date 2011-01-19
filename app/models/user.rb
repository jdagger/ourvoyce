require 'digest/sha2'
require 'email_validator'

class User < ActiveRecord::Base
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