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
@capsule = Capsule.get params[:image_token]
erb :capsule
end

post '/users/new' do
u = User.create(:email => params[:email])
u.save
u.user_token = u.generate_user_token
u.save
u.send_confirmation!
puts params[:email]
end

get "users/:user_token" do
@user = User.get params[:user_token]
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

#params[:file] = params[:file].unpack("m")[0]



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



dueDate = params[:date]
puts "Formatted Date:"
puts dueDate




c = Capsule.create(:created_at => t, :dueDate => dueDate,  :email => params[:email], :caption =>params[:caption])
   c.path = c.path_string
   c.image_token = c.generate_token
   c.save

  
  
    AWS::S3::Base.establish_connection!(:access_key_id => "AKIAI7S3OIOUYPQPFDAA", :secret_access_key => "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")
    
    AWS::S3::S3Object.store(c.path, image.to_blob, "hindsight-itp", :access => :public_read)


  rescue Exception => e
  	puts e
  	500
  end
  
end