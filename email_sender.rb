require 'pony'
require 'erb'

class EmailSender
  def self.send(params)
      Pony.mail :to => params[:address],
            :from => 'Throwback@throwback-app.com',
            :subject => params[:subject],
            :body => params[:body], 
            :html_body => erb(:hello_email),
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

 