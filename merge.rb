require 'models'
require 'digest/md5'

digest = Digest::MD5.hexdigest("Hello World\n")
  puts digest
  
