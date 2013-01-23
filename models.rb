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
  property :password, 	String
  property :confirmed, 	Boolean, :default => false
   
  has n, :capsules
  has n, :taggings
  has n, :tagged_capsules, 'Capsule', :through => :taggings, :via => :capsule
   
  validates_uniqueness_of :email
  validates_format_of :email, :as => :email_address
 
  def generate_user_token
  	Digest::MD5.hexdigest((Time.now.to_s + rand(10000).to_s))
  end
  
  def send_confirmation!  
  	EmailSender.send(:address => self.email, :subject => "Confirm your email", :body => "Thanks for signing up for Throwback! 
  	
Before you can start sending throwbacks, we need need you to confirm that this is the right email address to send your photos back to you. Can you do so by clicking the link below?
  	
http://throwback-app.com/users/#{self.user_token}")
  end
  
  def send_reset!  
  	EmailSender.send(:address => self.email, :subject => "Reset password from Throwback", :body => "Looks like you need a new password! Follow the link below to make a new one.
  	
http://throwback-app.com/users/reset/#{self.user_token}")
  end
  
  def send_welcome_email! 
  	EmailSender.send(:address => self.email, :subject => "Welcome to Throwback", :body => "Thanks for joining Throwback!") 
  	
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
  property :viewed,		Boolean, :default => false	
  belongs_to :user
  has n, :taggings
  has n, :tagged_users, 'User', :through => :taggings, :via => :user  
 
 	def self.send_due_capsules_to_tagged_users!
  	# get all due_capsules, even if they've been sent to their owners
  		due_capsules = self.due_capsules_for_tagged_users
  	# for each due_capsule
  	  		due_capsules.each do |due_capsule| 
  	# get the image path
  					
  	  				image_path = due_capsule.image_token
  	  				owner = due_capsule.user.email
  	  				  	#go through each one and send it to the user
  					due_capsule.taggings.each do |tag|
  						# tell the capsule to send
  						
  						EmailSender.send(:address => tag.user.email, :subject => "Here's your Throwback!", :body => "You've received a Throwback from " + owner +". Click the link below to view your photo.
  						
  http://throwback-app.com/capsules/" + image_path)
  						# set the tag flag to true
  						tag.sent = true
  						tag.save
  					end
  			end
  	end  	

 
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
  	Digest::MD5.hexdigest(self.id.to_s + Time.now.to_s + rand(10000).to_s)
  end

  
  def self.due_capsules
  	# get all the capsules whose dueDate is less than the current DateTime
	Capsule.all(:dueDate.lt=> Time.now, :sent => false)
  	# and whose sent flag is not true
  end
  
  def self.due_capsules_for_tagged_users
  	# get all the capsules whose dueDate is less than the current DateTime
	caps = Capsule.all(:dueDate.lt=> Time.now)   	# and whose sent flag is not true
	unsent_caps = caps.find_all { |capsule| capsule.taggings.all(:sent => false, :confirmed =>true).size > 0}
	unsent_caps
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
  	EmailSender.send(:address => self.user.email, :subject => "Here's your Throwback!", :body => "Thanks for being an early user of Throwback, the app that lets you send memories to your future self. A Throwback you took on " + self.formatted_created_at + " is ready for you! Click the link below to view your photo.
  	
http://throwback-app.com/capsules/#{self.image_token}

Love,
Team Throwback"

)
  end
  
   def send_to_tagged_user!  
  	EmailSender.send(:address => self.email, :subject => "Here's your Throwback!", :body => "You've received a Throwback from http://throwback-app.com/capsules/#{self.image_token}")
  end
  
  
end

class Tagging

  include DataMapper::Resource
 # property :id,         Serial  
  property :token, 		String  
  property :confirmed, 	Boolean, :default => false
  property :sent,		Boolean, :default => false	
  
  belongs_to :capsule, :key => true
  belongs_to :user, :key => true
  
  def generate_tag_token
  	Digest::MD5.hexdigest((Time.now.to_s + rand(10000).to_s))
  end
  
  def send_new_user_tag_request!
    owner = self.capsule.user.email
	EmailSender.send(:address => self.user.email, :subject => "Join Throwback today!", :body => "You've been tagged in a Throwback from " + owner + ".

Before you can start to receive Throwbacks, you need to make an account. Please visit the link below to set up an account so you can receive a copy of " + owner + "'s Throwback
  		
http://throwback-app.com/tag/new_user/#{self.token}
  		  		
  		")
  end
  
   def send_tag_request!  
    owner = self.capsule.user.email
  	EmailSender.send(:address => self.user.email, :subject => "Request for tag", :body => "You've been tagged in a Throwback from " + owner + ".
  		
Let us know if you want a copy of your capsule sent to you in the future by clicking the link below:
  		
http://throwback-app.com/tag/#{self.token}
  		  		
  		")
  end



  
 end
 
 DataMapper.finalize