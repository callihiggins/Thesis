require 'models'

Capsule.all.each do |c|
	puts "Creating user token for #{c.id}"

	c.image_token = c.generate_image_token
	c.save

end