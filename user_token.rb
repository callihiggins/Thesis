require 'models'

User.all.each do |u|
	puts "Creating user token for #{u.id}"

	u.user_token = u.generate_user_token
	u.save

end