require 'dm-core'
require 'dm-migrations'
require 'aws/s3'


DataMapper.setup(:default, ENV['DATABASE_URL'] || 'sqlite3:///Users/Calli/Documents/ITP/Spring_11/Thesis/code/hindsight.db')
    
class Capsule

  include DataMapper::Resource

  property :id,         Serial    
  
  property :dueDate, DateTime  
  property :email, String
  
  property :path,       String    
  #property :body,       Text      
  #property :created_at, DateTime
  
  
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
  
end