require 'spec_helper'

describe User do
  
	before(:each) do
		pending "The password system is temporary"
		@attr = { 
			:name => "Example User", 
			:email => "user@example.com", 
			:password => 'foobar',
			:password_confirmation => 'foobar',
			:nation => 'england'
		}
	end
	
	it "should create a new instance given valid attributes" do
		User.create!(@attr)
	end
	
	it "should require a name" do
		no_name_user = User.new(@attr.merge(:name => ''))
		no_name_user.should_not be_valid
	end
	
	it "should require an email" do
		no_email_user = User.new(@attr.merge(:email => ''))
		no_email_user.should_not be_valid
	end
	
	it "should reject names that are too long"	do 
		long_name = 'a' * 51
		long_name_user = User.new(@attr.merge(:name => long_name))
		long_name_user.should_not be_valid
	end
	
	it "should reject invalid emails" do
		invalid_email = "hello.a@sd"
		invalid_email_user = User.new(@attr.merge(:email => invalid_email))
		invalid_email_user.should_not be_valid
	end
	
	it "should email a user" do
		User.create!(@attr).should be_valid
	end
	
	it "should reject duplicate email addresses" do
		User.create!(@attr)
		duplicate_user = User.new(@attr)
		duplicate_user.should_not be_valid
	end
	
	it "should create a new instance given valid attributes" do
		User.create!(@attr)
	end
	
	describe "password validations" do
		
		it 'should require a matching password confirmation' do
			User.new(@attr.merge(:password_confirmation => 'invalid')).
				should_not be_valid # This might not work!
		end

	end
	
	describe 'password encryption' do
		
		before(:each) do
			@user = User.create!(@attr)
		end
		
		it 'should have an encrypted password attribute' do
			@user.should respond_to(:encrypted_password)
		end
		
		it 'should set the encrypted password' do
			@user.encrypted_password.should_not be_blank
		end
		
		describe 'has_password? method' do
		
			it 'should return true for the same password' do
				@user.has_password?(@attr[:password]).should be_true
			end
		
			it 'should return false for different passwords' do
				@user.has_password?('invalid').should be_false
			end
			
		end
		
		describe 'authenticate method' do
			
			it 'should return nil on email/password mismatch' do
				wrong_password_user = User.authenticate(@attr[:email], 'wrongpass')
				wrong_password_user.should be_nil
			end
			
			it 'should return nil for an email address with no user' do
				nonexistent_user = User.authenticate('bar@foo.com', @attr[:password])
				nonexistent_user.should be_nil
			end
			
			it 'should return the user on email/password match' do
				matching_user = User.authenticate(@attr[:email], @attr[:password])
				matching_user.should == @user
			end
		end
			
		
	end
end
