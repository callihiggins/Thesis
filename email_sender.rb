require 'pony'
require 'sinatra' # 'sinatra/base'
require 'erb'



class EmailSender

  def self.send(params)
        Pony.mail :to => params[:address],
            :from => 'ThrowBack',
            :subject => params[:subject],
            :headers => { 'Content-Type' => 'text/html' },
            :body => params[:body], 
            :reply-to => "hi@throwback-app.com"
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

 