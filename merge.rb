require 'models'

Capsule.all.each do |c|
	puts "Creating user for #{c.email}"

	u = User.create! :email => c.email, :confirmed => true
	c.user = u
	c.save!

end