class SessionsController < ApplicationController

	def new
		@title = "Sign In!"
	end
	
	def create
		user = User.authenticate(params[:session][:email], params[:session][:password])
		if user.nil?
			# Failed authentication
			flash.now[:error] = "Invalid email/password combination."
			@title = "Sign In!"
			render 'new'
		else
			# Successful authentication
			sign_in user
			redirect_back_or user
		end
	end

	def destroy
		sign_out
		redirect_to root_path
	end
end
