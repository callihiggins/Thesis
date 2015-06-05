source "https://rubygems.org"
ruby "2.0.0"

gem "sinatra"
gem "dm-core"
gem 'dm-migrations'
gem 'dm-validations'
gem 'pony'
gem 'pg'
gem 'puma'
gem 'aws-s3', :require => "aws/s3"
gem 'rmagick', :require => "RMagick"

group :development, :test do
  gem 'dm-sqlite-adapter'
  gem 'sqlite3'
  gem 'do_sqlite3'
end

group :production do 
  gem 'dm-postgres-adapter'
  gem 'do_postgres'
end
