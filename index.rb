require 'rubygems'
require 'sinatra'
require 'aws/s3'
require 'models'
require "base64"
require 'RMagick'

set :views, File.dirname(__FILE__) + '/views'

get '/' do
  "<h1>Welcome to memento</h1>"
end

get "/capsules/new" do
	erb :new_capsule
end

get "/capsules/:id" do
	# show the image plus some info about it
	@capsule = Capsule.get params[:id]
	erb :capsule
end

post '/capsules' do
	
   if params[:file]
   
   
	if params[:file][:tempfile] # this only happens through the browser
		image_file = params[:file][:tempfile]
	else 
	  	image_file = Magick::Image.from_blob(params[:file].unpack("m")[0]).first
	end
  	# read the user input from the form (input tag with name="email") from params[:email]
  	puts image.inspect
  	
  	
    #filename = params[:file][:filename] # CHANGEME: generate one based on the Capsule id
    
	# generate a random time
	t = Time.now
	currentyear = t.year
	year = 2010
	month = rand(11)
	day = rand(28)
	
	c = Capsule.create(:created_at => Time.now(), :dueDate => DateTime.new(year, month, day, 12), :email => params[:email])
  	c.path = c.path_string
  	c.save
  	
  #	puts "http://memento.heroku.com/capusles/#{c.id}"
  	
  	   
    AWS::S3::Base.establish_connection!(:access_key_id => "AKIAI7S3OIOUYPQPFDAA", :secret_access_key => "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")
    
    AWS::S3::S3Object.store(c.path, image_file, "hindsight-itp", :access => :public_read)
	

  	"Thanks"
  else
    "You have to choose a file"
  end

  
end


  
