require 'pony'
require 'sinatra' # 'sinatra/base'
require 'erb'



class EmailSender

  def self.send(params)
  body = ERB.new(File.read('./views/new_user_tag.erb'))
	body.result(binding)
      Pony.mail :to => params[:address],
            :from => 'Throwback@throwback-app.com',
            :subject => params[:subject],
            :headers => { 'Content-Type' => 'text/html' },
            :body => params[:body], 
            :html_body => body,
            :via => :smtp,
            :via_options => { 
                :address   => 'smtp.sendgrid.net', 
                :port   => '25', 
                :user_name   => ENV['SENDGRID_USERNAME'], 
                :password   => ENV['SENDGRID_PASSWORD'],
                :authorization => :plain,
                :domain => ENV['SENDGRID_DOMAIN']
              } 
  end
end

 