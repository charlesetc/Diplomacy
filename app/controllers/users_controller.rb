class UsersController < ApplicationController
	before_filter :authenticate, :only => [:edit, :update]
	before_filter :correct_user, :only => [:edit, :update]
	
	def index
		@title = @heading ='Players'
		@users = User.all
	end
	
	
	
	
  def new
		@user = User.new 
		@heading = 'Join'
		@title = 'Join'
  end
	
	
	
	def destroy
	    User.find(params[:id]).destroy
	    flash[:success] = "User destroyed."
	    redirect_to users_url
	end
	
	
	
	def show
		@user = User.find(params[:id])
		@heading = @user.name.split(' ')[0]
		@units = @user.units
		render 'show'
	end
	
	def update_bio
		@user = User.find(params[:id])
		@user.update_column(:bio, params[:user][:bio])
		redirect_to show_path(@user)
	end
	
	def create
		@user = User.new(params[:user])
    @user.email = params[:user][:email].downcase
		if @user.save
			sign_in @user
			flash[:success] = 'Welcome to the sample app!'
			redirect_to @user
		else
			@heading = 'Join'
			@title = 'Join'
			render 'new'
		end
	end
	
	
	
	def edit
		@user = User.find(params[:id])
		@edit_count = 0
		if params[:color]
			set_color(params[:color])
		end
		@title = @heading = "Settings"
	end
	
	
	
	def update
		@user = User.find(params[:id])
			
		if @user.update_attributes(params[:user])
			flash[:success] = "Profile updated!"
			redirect_to @user
		else
			@title = @heading = "Edit User"
			@edit_count = 1
			render 'edit'
		end
		
	end

	
	private
	
		def authenticate
			deny_access unless signed_in?
		end
		
		def correct_user
			@user = User.find(params[:id])
			redirect_to(root_path) unless current_user?(@user)
		end
		
end
