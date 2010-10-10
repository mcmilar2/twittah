class UsersController < ApplicationController
	
	before_filter :authenticate,		:only => [:index, :edit, :update, :destroy]
	before_filter :correct_user,		:only => [:edit, :update]
	before_filter :admin_user,			:only => [:destroy]
	before_filter :new_users_only,		:only => [:new, :create]

	def new
		@user = User.new
		@title = 'Sign Up!'
	end
	
	def show
		@user = User.find(params[:id])
		@microposts = @user.microposts.paginate(:page => params[:page])
		@title = @user.name
	end

	def create
		@user = User.new(params[:user])
		if @user.save
			sign_in @user
			flash[:success] = "Welcome to twittah!"
			redirect_to @user
		else
			@title = "Sign Up!"
			@user.password = ""
			@user.password_confirmation = ""
			render 'new'
		end
	end

	def edit
		@title = "Edit User"
	end

	def update
		@user = User.find(params[:id])
		if @user.update_attributes(params[:user])
			flash[:success] = "Profile Updated."
			redirect_to @user
		else
			@title = "Edit User"
			render 'edit'
		end
	end

	def index
		@users = User.paginate(:page => params[:page])
		@title = "All Users"
	end

	def destroy
		User.find(params[:id]).destroy
		flash[:success] = "User deleted."
		redirect_to users_path
	end

	private
		def correct_user
			@user = User.find(params[:id])
			redirect_to root_path unless current_user?(@user)
		end

		def admin_user
			if current_user == User.find(params[:id])
				flash[:error] = "You cannot delete yourself!"
				redirect_to users_path
			elsif !current_user.admin?
				flash[:error] = "You are not an admin."
				redirect_to users_path
			end
		end

		def new_users_only
			if signed_in?
				flash[:error] = "You are only allowed one account.  Please logout first."
				redirect_to user_path(current_user)
			end
		end
end
