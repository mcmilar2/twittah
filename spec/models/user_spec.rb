require 'spec_helper'

describe User do
	before(:each) do
		@attr = {
			:name 					=> "Example User",
			:email 					=> "user@example.com",
			:password 				=> "foobar",
			:password_confirmation 	=> "foobar"
		}
	end

	it "should create a new instance given valid attributes" do
		User.create!(@attr)
	end

	##############################
	# Name tests
	##############################

	it "should require a name" do
		no_name_user = User.new(@attr.merge(:name => ""))
		no_name_user.should_not be_valid
	end
	
	it "should reject names that are too long" do
		long_name = "a" * 51
		long_name_user = User.new(@attr.merge(:name => long_name))
		long_name_user.should_not be_valid
	end

	##############################
	# Email tests
	##############################

	it "should require an email address" do
		User.new(@attr.merge(:email => "")).should_not be_valid
	end
	
	it "should accept valid email addresses" do
		valid_emails = %w[user@foo.com THE_USER@foo.bar.org first.last@foo.jp]
		valid_emails.each do |address|
			hash = @attr.merge(:email => address)
			User.new(hash).should be_valid
		end
	end
	
	it "should reject invalid email addresses" do
		invalid_emails = %w[user@foo,com user_at_foo.org example.user@foo.]
		invalid_emails.each do |address|
			hash = @attr.merge(:email => address)
			User.new(hash).should_not be_valid
		end
	end

	it "should reject duplicate email addresses" do
		User.create!(@attr)
		User.new(@attr).should_not be_valid
	end
	
	it "should reject duplicate email addresses with different casing" do
		upcased_email = @attr[:email].upcase
		hash = @attr.merge(:email => upcased_email)
		User.create!(@attr)
		User.new(hash).should_not be_valid
	end	

	##############################
	# Password tests
	##############################
	
	describe "password validations" do
		it "should require a password" do
			hash = @attr.merge(:password => "", :password_confirmation => "")
			User.new(hash).should_not be_valid
		end
	
		it "should require that the password matches the password confirmation" do
			hash=@attr.merge(:password_confirmation => "invalid")
			User.new(hash).should_not be_valid
		end
		
		it "should reject short passwords" do
			too_short = "a" * 5
			hash = @attr.merge(:password => too_short, :password_confirmation => too_short)
			User.new(hash).should_not be_valid
		end
		
		it "should reject long passwords" do
			too_long = "a" * 41
			hash = @attr.merge(:password => too_long, :password_confirmation => too_long)
			User.new(hash).should_not be_valid
		end
	end
	
	describe "password encryption" do
		before(:each) do
			@user = User.create!(@attr)
		end
		
		it "should have an encrypted password attribute" do
			@user.should respond_to(:encrypted_password)
		end

		it "should set the encrypted password" do
			@user.encrypted_password.should_not be_blank
		end
	
		describe "has_password? method" do
			it "should be true if the passwords match" do
				@user.has_password?(@attr[:password]).should be_true
			end

			it "should be false if the passwords dont match" do
				@user.has_password?("invalid").should be_false
			end
		end
	
		describe "authenticate method" do
			it "should return nil on email/password mismatch" do
				wrong_password_user = User.authenticate(@attr[:email], "wrongpass")
				wrong_password_user.should be_nil
			end
	
			it "should return nil for an email address with no user" do
				nonexistant_user = User.authenticate("foo@bar.com", @attr[:password])
				nonexistant_user.should be_nil
			end
			
			it "should return the user on email/password match" do
				matching_user = User.authenticate(@attr[:email], @attr[:password])
				matching_user.should == @user
			end
		end				
	end

	###################################################
	###### Other
	###################################################

	describe "admin attribute" do
		before(:each) do
			@user = User.create!(@attr)
		end
		
		it "should respond to admin" do
			@user.should respond_to(:admin)
		end

		it "should not be an admin by default" do
			@user.should_not be_admin
		end

		it "should be convertible to an admin" do
			@user.toggle!(:admin)
			@user.should be_admin
		end
	end
end
