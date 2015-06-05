require 'rubygems'
require 'sinatra'
require 'aws/s3'
require './models'
require "base64"
require 'RMagick'

configure {
  set :server, :puma
}

set :views, File.dirname(__FILE__) + '/views'

get '/' do

erb :home, :layout => false 

end

get "/capsules/new" do
erb :new_capsule

end

get "/capsules/:image_token" do
# show the image plus some info about it
@capsule = Capsule.first :image_token => params[:image_token]
@capsule.viewed = true
@capsule.save

erb :capsule, :layout => false 
end

get "/capsules/:id" do
# show the image plus some info about it
@capsule = Capsule.get params[:id]
@capsule.viewed = true
@capsule.save
erb :capsule
end

get "/tag/:token" do
# show the image plus some info about it
token_tag = params[:token]
@tag = Tagging.first(:token=>token_tag)
@tag.confirmed = true
@tag.save
@user = @tag.capsule.user
erb :tag
end

get "/tag/new_user/:token" do
# show the image plus some info about it
token_tag = params[:token]
@tag = Tagging.first(:token=>token_tag)
erb :new_user_tag
end

post '/tag/newuser/:token' do
password = params[:password]
email = params[:email]
puts email
new_password = Digest::MD5.hexdigest(password)
u = User.first(:email => email)
puts u
u.update(:password => new_password, :user_token => u.generate_user_token)
u.save
token_tag = params[:token]
@tag = Tagging.first(:token=>token_tag)
@tag.confirmed = true
@tag.save
	if u.save 
     	u.send_welcome_email!
		erb :new_user_tag_confirmed
	else my_error_string = u.errors.collect do |e| 
			 e[0] 
		 	end.join(",")	
		my_error_string
	end
end

post '/users/check' do
puts params[:email]
user = User.first :email => params[:email]
password = params[:password]
new_password = Digest::MD5.hexdigest(password)
	if user.nil? 
	"You need to create an account"
	elsif user.confirmed && user.password == new_password
	"Logging in"
	elsif user.password != new_password
	"Incorrect password"
	elsif user.confirmed == false
	"You need to register your email" 
	else my_error_string = user.errors.collect do |e| 
			 e[0] 
		 end.join(",")	
		my_error_string
	end
end

post '/users/new' do
email = params[:email]
password = params[:password]
new_password = Digest::MD5.hexdigest(password)
u = User.first :email => email
	if u.nil? 
		u = User.new(:email => email, :password => new_password, :confirmed=>true)
		u.user_token = u.generate_user_token
		if u.save 
			u.send_confirmation!
		 else my_error_string = u.errors.collect do |e| 
			 e[0] 
		 	end.join(",")	
		my_error_string
		end
		else 
		u.send_confirmation!
		"You already have an account"
	end
end

post '/users/reset' do
email = params[:email]
puts email
u = User.first :email => email
	if u.nil? 
		"User doesn't exist"
		else 
		u.send_reset!
 	end
end

get "/users/reset/:user_token" do
@user = User.first :user_token => params[:user_token]
erb :reset
end

post "/users/reset_confirm/:user_token" do
user = User.first :user_token => params[:user_token]
password = params[:password]
new_password = Digest::MD5.hexdigest(password) 
user.update(:password=> new_password)
	if user.save
	erb :password_confirmed
	else my_error_string = u.errors.collect do |e| 
			 e[0] 
		 	end.join(",")	
		my_error_string
	end
end

get "/users/:user_token" do
@user = User.first :user_token => params[:user_token]
@user.confirmed = true
@user.save
erb :user
end


get "/hello_email" do

erb :hello_email, :layout => true
end

post '/capsules' do
  
  #def iphone_upload
  # @data = request.POST[:imageData].unpack("m")[0]
  # fileout = "/var/www/test.jpg"
  # File.open(fileout, 'w') {|f| f.write(@data) }
  # end
  
  puts "************FILE UPLOAD*********************"
  puts "Params:"
puts params

puts "File:"
puts params[:file]
puts "Email:"
puts params[:email]
puts "Caption:"
puts params[:caption]
     
  puts "************/FILE UPLOAD*********************"

   begin
   image = Magick::Image.read(params[:file][:tempfile].path)[0]

	#if image.size > 500000
	#	return 400, "photo too big"
	#end	

   ##image = Magick::Image.from_blob(params[:file][:tempfile].read).first
   image.auto_orient!

# generate a random time
t = Time.now
currentyear = t.year
year = currentyear + rand(6)
month = rand(11)
day = rand(28)

user = User.first(:email=> params[:email])







dueDate = params[:date]
puts "Formatted Date:"
puts dueDate



   c = Capsule.create(:created_at => t, :dueDate => dueDate,  :caption =>params[:caption])
   c.user = user
   c.image_token = c.generate_image_token
   c.path = c.path_string
   c.save!
   
   tags = params[:tags]
   puts tags

	if tags
	   tags = tags.delete(' ')
	   tagged_users = tags.split(",").each 
	   tagged_users.each do |tagged_user|
       	user = User.first(:email => tagged_user)
  			if user.nil?
	  #make them an account but send them an email to pick a password and confirm it
			  user = User.new(:email=> tagged_user)
			  tag = c.taggings.new(:user => user)
			  tag_token = tag.generate_tag_token
			  tag.save
			  user.save
	 		  tag.update(:token => tag_token)
			  c.save!
	 	 	  tag.send_new_user_tag_request! 
 			 else
 	 	 	tag = c.taggings.new(:user => user)
 			tag_token = tag.generate_tag_token
 			tag.save
 			tag.update(:token => tag_token)
 		  #send cofirmation link
 		  	c.save!
 		  	tag.send_tag_request!
			end  
		end
	end

 
   
 

  
  
    AWS::S3::Base.establish_connection!(:access_key_id => "AKIAI7S3OIOUYPQPFDAA", :secret_access_key => "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")
    
    AWS::S3::S3Object.store(c.path, image.to_blob, "hindsight-itp", :access => :public_read)
	

  rescue Exception => e
  	puts e
  	500
  	end
  
end