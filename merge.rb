require 'models'
require 'digest/md5'

Capsule.all.each do |c|
	puts "Creating user for #{c.id}"

	c.image_token = Digest::MD5.hexdigest(c.id.to_s)
	c.save!

end