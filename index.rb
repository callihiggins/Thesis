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
	if user.nil? 
	puts 'no user'
	"no user"
	elsif user.confirmed
	puts 'confirmed'
	"exists"
	else
	puts "error"
	"error"
	end
end

post '/users/new' do
email = params[:email]
u = User.first :email => email
	if u.nil? 
		u = User.new(:email => email)
		u.save
		u.user_token = u.generate_user_token
		if u.save 
			u.send_confirmation!
		 else u.errors.collect do |e|
			e[1]        
			end.join(",")	
    	end
    	end
	else
		u.send_confirmation!
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
   c.path = c.path_string
   c.user = user
   c.image_token = c.generate_image_token
   c.save

  
  
    AWS::S3::Base.establish_connection!(:access_key_id => "AKIAI7S3OIOUYPQPFDAA", :secret_access_key => "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")
    
    AWS::S3::S3Object.store(c.path, image.to_blob, "hindsight-itp", :access => :public_read)


  rescue Exception => e
  	puts e
  	500
  end
  
end