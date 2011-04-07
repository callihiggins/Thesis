require 'rubygems'
require 'sinatra'
require 'aws/s3'
require 'models'

set :views, File.dirname(__FILE__) + '/views'


#TODO:
# add created_at property on Capsule (DateTime)
# when creating a Capsule (i.e. in post "/capsules") set the created_at property to the current time
# randomly generate a DateTime for dueDate based on a range

get '/' do
  "<h1>Welcome to Hindsight</h1>"
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
  	# create a new Capsule object and store it in the dabase 
  	# Capsule.create :email => params[:email]
  	
    filename = params[:file][:filename] # CHANGEME: generate one based on the Capsule id
    file = params[:file][:tempfile]

   	# make a new capsule
	# set dueDate to a fixed date
	# set path to filename we just gave aws
	# set email to a fixed email (I suggest yours)
	# save the capsule
    
	c = Capsule.create(:dueDate => DateTime.new(2012, 12, 1, 12), :email => params[:email])
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


  
