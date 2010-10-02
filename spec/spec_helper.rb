# This file is copied to ~/spec when you run 'ruby script/generate rspec'
# from the project root directory.

require 'rubygems' #added
require 'spork' #added 
Spork.prefork do #added
 
	ENV["RAILS_ENV"] ||= 'test'
	unless defined?(Rails) #added
		require File.dirname(__FILE__) + "/../config/environment" #added
	end #added	
	##require File.expand_path("../../config/environment", __FILE__) #removed
	require 'rspec/rails'
	
	# Requires supporting files with custom matchers and macros, etc,
	# in ./support/ and its subdirectories.
	Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each {|f| require f}
	
	RSpec.configure do |config|
	  # == Mock Framework
	  #
	  # If you prefer to use mocha, flexmock or RR, uncomment the appropriate line:
	  #
	  # config.mock_with :mocha
	  # config.mock_with :flexmock
	  # config.mock_with :rr
	  config.mock_with :rspec
	
	  config.fixture_path = "#{::Rails.root}/spec/fixtures"
	
	  # If you're not using ActiveRecord, or you'd prefer not to run each of your
	  # examples within a transaction, comment the following line or assign false
	  # instead of true.
	  config.use_transactional_fixtures = true

	  ### Part of a Spork hack.  See http://bit.ly/arY19y #added
	  # emulate initializer set_clear_dependencies_hook in #added
	  # railties/lib/rails/applicatoin/bootstrap.rb #added
	  ActiveSupport::Dependencies.clear #added
	end
end #added

Spork.each_run do #added
end #added
