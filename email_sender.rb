require 'pony'

class EmailSender
  def self.send(params)
     Pony.mail :to => params[:address],
            :from => 'Throwback@throwback-app.com',
            :subject => params[:subject],
            :port => '587',
            :body => params[:body], 
            :headers => { 'Content-Type' => 'text/html' },
            :html_body => params[:html_body],
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