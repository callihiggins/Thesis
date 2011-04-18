require 'rubygems'
require 'sinatra'
require 'aws/s3'
require 'models'

set :views, File.dirname(__FILE__) + '/views'


#TODO:

# randomly generate a DateTime for dueDate based on a range

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
  
  	# read the user input from the form (input tag with name="email") from params[:email]
  	
    filename = params[:file][:filename] # CHANGEME: generate one based on the Capsule id
    file = params[:file][:tempfile]
    
	# generate a random time
	t = Time.now
	currentyear = t.year
	year = currentyear + rand(6)
	month = rand(12)
	day = rand(28)
	
	c = Capsule.create(:created_at => Time.now(), :dueDate => DateTime.new(year, month, day, 12), :email => params[:email])
  	c.path = c.path_string(filename)
  	# set c.created_at to the current time
  	c.save
   
    AWS::S3::Base.establish_connection!(:access_key_id => "AKIAI7S3OIOUYPQPFDAA", :secret_access_key => "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")
    
    AWS::S3::S3Object.store(c.path, open(file), "hindsight-itp", :access => :public_read)
	

  	"Thanks"
  else
    "You have to choose a file"
  end

  
end


  
