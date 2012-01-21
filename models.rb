require 'rubygems'
require 'dm-core'
require 'dm-migrations'
require 'dm-validations'
require 'aws/s3'
require 'email_sender'
require 'digest/md5'


DataMapper.setup(:default, ENV['DATABASE_URL'] || 'sqlite3:///Users/Calli/Documents/ITP/Spring_11/Thesis/code/hindsight.db')
    
class User
  include DataMapper::Resource

  property :id,         Serial   
  property :email,		String
  property :user_token,	String
  property :password, 		String
  property :confirmed, 	Boolean, :default => false
    
  has n, :capsules
  
  validates_uniqueness_of :email
  validates_format_of :email, :as => :email_address
 
  def generate_user_token
  	Digest::MD5.hexdigest((Time.now.to_s + rand(10000).to_s))
  end
  
  def send_confirmation!  
  	EmailSender.send(:address => self.email, :subject => "Confirm your email", :body => "http://memento-app.com/users/#{self.user_token}")
  end

    
  
end
    
class Capsule

  include DataMapper::Resource

  property :id,         Serial    
  property :image_token,String
  property :dueDate, 	DateTime 
  property :caption,	Text, :lazy => false
  property :path,       String 
  property :created_at, DateTime
  property :sent,		Boolean, :default => false	
	
  belongs_to :user

  def self.send_due_capsules!
  	# get all due_capsules
  		due_capsules = self.due_capsules
  	# for each due_capsule
  	  		due_capsules.each do |due_capsule| 
  	# tell the capsule to send
  			due_capsule.send!
  	# set the sent property to true
  	#	due_capsule.update(:sent => true)  
  	  		due_capsule.sent = true
  	# and save the capsule 		
  			due_capsule.save
  		end  
  	end
   
   def generate_image_token
  	Digest::MD5.hexdigest(self.id.to_s)
  end

  
  def self.due_capsules
  	# get all the capsules whose dueDate is less than the current DateTime
	Capsule.all(:dueDate.lt=> Time.now, :sent => false)
  	# and whose sent flag is not true
  end
  
  def formatted_created_at
  	self.created_at.strftime("%B %d, %Y at %I:%M%p")
  end
  
  def string_to_date
 	 strptime(self, fmt=' %a %B %d %Y %H:%M:%S %z')
  end
  

  
  def path_string
  #"foo.jpg" "foo.tiff"
  	extension="jpg"
  	#extension = filename.split(".").last
  	"capsule_#{self.image_token}.#{extension}"
  end
  
  def image_url
  	 AWS::S3::Base.establish_connection!(:access_key_id => "AKIAI7S3OIOUYPQPFDAA", :secret_access_key => "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")
  	 bucket = AWS::S3::Bucket.find 'hindsight-itp'
  	 bucket[self.path].url
  end
  
  def send!  
  	EmailSender.send(:address => self.user.email, :subject => "Here's your capsule!", :body => "http://memento-app.com/capsules/#{self.image_token}")
  end
  
end