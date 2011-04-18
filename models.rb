require 'dm-core'
require 'dm-migrations'
require 'aws/s3'
require 'email_sender'


DataMapper.setup(:default, ENV['DATABASE_URL'] || 'sqlite3:///Users/Calli/Documents/ITP/Spring_11/Thesis/code/hindsight.db')
    
class Capsule

  include DataMapper::Resource

  property :id,         Serial    
  
  property :dueDate, 	DateTime 
  property :email, 		String
  
  property :path,       String    
  #property :body,       Text      
  property :created_at, DateTime
 # property :sent,		Boolean, :default => false
  
  
  #TODO:
  #-> add sent property as a boolean that defaults to false - yes
  #-> implement Capsule.due_capsules method 
  #-> implement Capsule.send_due_capsules!
  #-> create a Rakefile based on Greg's github cron example
  #-> in the Rakefile task call Capsule.send_due_capsules!
  #-> add the cron addon to your app on heroku
  
 # def self.send_due_capsules!
  	# get all due_capsules
  	# for each due_capsule
  	# tell the capsule to send
  	# set the sent property to true
  	# and save the capsule 
#  end
  
  
#  def self.due_capsules
  	# get all the capsules whose dueDate is less than the current DateTime
  #	Capsule.all :dueDate.lt => DateTime.now :sent == false
  	# and whose sent flag is not true
 # end
  
  def path_string(filename)
  #"foo.jpg" "foo.tiff"
  	extension = filename.split(".").last
  	"capsule_#{self.id}.#{extension}"
  end
  
  def image_url
  	 AWS::S3::Base.establish_connection!(:access_key_id => "AKIAI7S3OIOUYPQPFDAA", :secret_access_key => "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")
  	 bucket = AWS::S3::Bucket.find 'hindsight-itp'
  	 bucket[self.path].url
  end
  
  def send!
  	EmailSender.send(:address => self.email, :subject => "Here's your capsule!", :body => "http://memento.heroku.com/capsules/#{self.id}")
  end
  
end