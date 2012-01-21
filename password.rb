require 'models'

User.all.each do |u|
	puts "Creating password for #{u.email}"

	u = u.update(:password => "5f4dcc3b5aa765d61d8327deb882cf99")	
	u.save!

end