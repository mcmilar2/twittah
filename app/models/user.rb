# == Schema Information
# Schema version: 20101008034124
#
# Table name: users
#
#  id             :integer         not null, primary key
#  name           :string(255)
#  email          :string(255)
#  created_at     :datetime
#  updated_at     :datetime
#  encrypted_pass :string(255)
#

require 'digest'

class User < ActiveRecord::Base
	attr_accessor :pass
	attr_accessible :name, :email, :pass, :pass_confirmation

	email_regex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
	
	validates :name, 	:presence 		=> true,
						:length			=> { :maximum => 50 }
	validates :email,	:presence 		=> true,
						:format 		=> { :with => email_regex },
						:uniqueness 	=> { :case_sensitive => false }
	validates :pass,	:presence		=> true,
						# automatically creates virtual attribute 'pass_confirmation'
						:confirmation	=> true,
						:length			=> { :within => 6..40 }

	before_save :encrypt_pass

	# Returns true if the submitted password matches the user's password
	def has_password?(submitted_password)
		encrypted_pass == encrypt(submitted_password)	
	end

	def self.authenticate(email, submitted_password)
		user = find_by_email(email)
		return nil if user.nil?
		return user if user.has_password?(submitted_password)
	end

	private
	def encrypt_pass
		self.salt = make_salt if new_record?
		self.encrypted_pass = encrypt(pass)
	end

	def encrypt(string)
		secure_hash("#{salt}--#{string}")
	end

	def make_salt
		secure_hash("#{Time.now.utc}--#{pass}")
	end
	
	def secure_hash(string)
		Digest::SHA2.hexdigest(string)
	end
end
