require 'rubygems'
require 'sinatra'
require 'aws/s3'
require 'models'
require "base64"
require 'RMagick'

set :views, File.dirname(__FILE__) + '/views'

get '/' do

"
<title>memento</title>
<style>
body {
background-color:333333;
background-position:center; 
background-image:url('http://memento.heroku.com/images/letter.png');
background-repeat:
no-repeat;
background-attachment:
fixed
}
</style>
<body>

</body>"
end

get "/capsules/new" do
erb :new_capsule

end

get "/capsules/:image_token" do
# show the image plus some info about it
@capsule = Capsule.first :image_token => params[:image_token]
erb :capsule
end

get "/capsules/:id" do
# show the image plus some info about it
@capsule = Capsule.get params[:id]
erb :capsule
end

post '/users/check' do
puts params[:email]
user = User.last :email => params[:email]
password = params[:password]
puts password
new_password = Digest::MD5.hexdigest(password)
puts new_password
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
puts password
new_password = Digest::MD5.hexdigest(password)
u = User.first :email => email
	if u.nil? 
		u = User.new(:email => email, :password => new_password)
		u.user_token = u.generate_user_token
		if u.save 
			u.send_confirmation!
		 else my_error_string = u.errors.collect do |e| 
			 e[0] 
		 	end.join(",")	
		my_error_string
		end
	elsif u.confirmed == true
		"You already have an account"
	else 
		u.send_confirmation!
		"Please check your email for a confirmation link"
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

post "/users/reset_confirm" do
password = params[:password]
new_password = Digest::MD5.hexdigest(password) 
@user.update(:password=> new_password)
	if @user.save
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

user = User.first(:email=>params[:email])




dueDate = params[:date]
puts "Formatted Date:"
puts dueDate

#how does user email get included


	c = Capsule.create(:created_at => t, :dueDate => dueDate,  :caption =>params[:caption])
   c.user = user
   c.image_token = c.generate_image_token
   c.path = c.path_string
   c.save!

  
  
    AWS::S3::Base.establish_connection!(:access_key_id => "AKIAI7S3OIOUYPQPFDAA", :secret_access_key => "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")
    
    AWS::S3::S3Object.store(c.path, image.to_blob, "hindsight-itp", :access => :public_read)


  rescue Exception => e
  	puts e
  	500
  end
  
end