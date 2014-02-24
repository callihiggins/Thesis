require 'rubygems'
require 'dm-core'
require 'dm-migrations'
require 'dm-validations'
require 'aws/s3'
require 'email_sender'
require 'digest/md5'


DataMapper.setup(:default, ENV['DATABASE_URL'] || 'sqlite3:///Users/Calli/Documents/ITP/Spring_11/Thesis/code/hindsight.db')
    
class User
  include DataMapper::Resource

  property :id,         Serial   
  property :email,		String
  property :user_token,	String
  property :password, 	String
  property :confirmed, 	Boolean, :default => false
   
  has n, :capsules
  has n, :taggings
  has n, :tagged_capsules, 'Capsule', :through => :taggings, :via => :capsule
   
  validates_uniqueness_of :email
  validates_format_of :email, :as => :email_address
 
  def generate_user_token
  	Digest::MD5.hexdigest((Time.now.to_s + rand(10000).to_s))
  end
  
  def send_confirmation!  
  	EmailSender.send(:address => self.email, :subject => "Confirm your email", :body => "Thanks for signing up for Throwback! 
  	
Before you can start sending throwbacks, we need need you to confirm that this is the right email address to send your photos back to you. Can you do so by clicking the link below?
  	
http://throwback-app.com/users/#{self.user_token}")
  end
  
  def send_reset!  
  	EmailSender.send(:address => self.email, :subject => "Reset password from Throwback", :body => "Looks like you need a new password! Follow the link below to make a new one.
  	
http://throwback-app.com/users/reset/#{self.user_token}")
  end
  
  def send_welcome_email! 
  	EmailSender.send(:address => self.email, :subject => "Welcome to Throwback", :body => "Thanks for joining Throwback!") 
  	
  	  end
  	  
  	   def send_hello_email! 
  	EmailSender.send(:address => self.email, :subject => "Welcome to Throwback", :html_body => "<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        
        <!-- Facebook sharing information tags -->
        
        
        <title>*|MC:SUBJECT|*</title>
		
	<style type="text/css">
		#outlook a{
			padding:0;
		}
		body{
			width:100% !important;
		}
		.ReadMsgBody{
			width:100%;
		}
		.ExternalClass{
			width:100%;
		}
		body{
			-webkit-text-size-adjust:none;
		}
		body{
			margin:0;
			padding:0;
		}
		img{
			border:0;
			line-height:100%;
			outline:none;
			text-decoration:none;
		}
		table td{
			border-collapse:collapse;
		}
		#backgroundTable{
			height:100% !important;
			margin:0;
			padding:0;
			width:100% !important;
		}
	/*
	@tab Page
	@section background color
	@tip Set the background color for your email. You may want to choose one that matches your company's branding.
	@theme page
	*/
		body,#backgroundTable{
			/*@editable*/background-color:#FFFFFF;
		}
	/*
	@tab Page
	@section heading 1
	@tip Set the styling for all first-level headings in your emails. These should be the largest of your headings.
	@style heading 1
	*/
		h1,.h1{
			/*@editable*/color:#303030;
			display:block;
			/*@editable*/font-family:Helvetica;
			/*@editable*/font-size:40px;
			/*@editable*/font-weight:bold;
			/*@editable*/line-height:100%;
			margin-top:0;
			margin-right:0;
			margin-bottom:10px;
			margin-left:0;
			/*@editable*/text-align:center;
		}
	/*
	@tab Page
	@section heading 2
	@tip Set the styling for all second-level headings in your emails.
	@style heading 2
	*/
		h2,.h2{
			/*@editable*/color:#303030;
			display:block;
			/*@editable*/font-family:Helvetica;
			/*@editable*/font-size:28px;
			/*@editable*/font-weight:bold;
			/*@editable*/line-height:100%;
			margin-top:0;
			margin-right:0;
			margin-bottom:10px;
			margin-left:0;
			/*@editable*/text-align:left;
		}
	/*
	@tab Page
	@section heading 3
	@tip Set the styling for all third-level headings in your emails.
	@style heading 3
	*/
		h3,.h3{
			/*@editable*/color:#303030;
			display:block;
			/*@editable*/font-family:Helvetica;
			/*@editable*/font-size:20px;
			/*@editable*/font-weight:bold;
			/*@editable*/line-height:100%;
			margin-top:0;
			margin-right:0;
			margin-bottom:10px;
			margin-left:0;
			/*@editable*/text-align:left;
		}
	/*
	@tab Page
	@section heading 4
	@tip Set the styling for all fourth-level headings in your emails. These should be the smallest of your headings.
	@style heading 4
	*/
		h4,.h4{
			/*@editable*/color:#303030;
			display:block;
			/*@editable*/font-family:Helvetica;
			/*@editable*/font-size:14px;
			/*@editable*/font-weight:bold;
			/*@editable*/line-height:100%;
			margin-top:0;
			margin-right:0;
			margin-bottom:10px;
			margin-left:0;
			/*@editable*/text-align:left;
		}
	/*
	@tab Header
	@section preheader style
	@tip Set the background color for your email's preheader area.
	@theme page
	*/
		#templatePreheader{
			/*@editable*/background-color:#EFEFEF;
		}
	/*
	@tab Header
	@section preheader text
	@tip Set the styling for your email's preheader text. Choose a size and color that is easy to read.
	*/
		.preheaderContent{
			/*@editable*/color:#505050;
			/*@editable*/font-family:Helvetica;
			/*@editable*/font-size:10px;
			/*@editable*/line-height:125%;
			/*@editable*/text-align:left;
		}
	/*
	@tab Header
	@section preheader link
	@tip Set the styling for your email's preheader links. Choose a color that helps them stand out from your text.
	*/
		.preheaderContent a:link,.preheaderContent a:visited,.preheaderContent a .yshortcuts {
			/*@editable*/color:#505050;
			/*@editable*/font-weight:normal;
			/*@editable*/text-decoration:underline;
		}
	/*
	@tab Header
	@section header text
	@tip Set the styling for your email's header text. Choose a size and color that is easy to read.
	*/
		.headerContent{
			/*@editable*/color:#303030;
			/*@editable*/font-family:Helvetica;
			/*@editable*/font-size:40px;
			/*@editable*/font-weight:bold;
			/*@editable*/line-height:100%;
			/*@editable*/text-align:center;
			/*@editable*/vertical-align:middle;
		}
	/*
	@tab Header
	@section header link
	@tip Set the styling for your email's header links. Choose a color that helps them stand out from your text.
	*/
		.headerContent a:link,.headerContent a:visited,.headerContent a .yshortcuts {
			/*@editable*/color:#EA5D41;
			/*@editable*/font-weight:normal;
			/*@editable*/text-decoration:underline;
		}
		#headerImage{
			height:auto;
			max-width:300px;
		}
	/*
	@tab Body
	@section body style
	@tip Set the top border for your email's body area.
	*/
		#templateBody{
			/*@editable*/border-top:1px solid #CCCCCC;
		}
	/*
	@tab Body
	@section body text
	@tip Set the styling for your email's main content text. Choose a size and color that is easy to read.
	@theme main
	*/
		.bodyContent{
			/*@editable*/color:#505050;
			/*@editable*/font-family:Helvetica;
			/*@editable*/font-size:15px;
			/*@editable*/line-height:150%;
			/*@editable*/text-align:left;
		}
	/*
	@tab Body
	@section body link
	@tip Set the styling for your email's main content links. Choose a color that helps them stand out from your text.
	*/
		.bodyContent a:link,.bodyContent a:visited,.bodyContent a .yshortcuts {
			/*@editable*/color:#EA5D41;
			/*@editable*/font-weight:normal;
			/*@editable*/text-decoration:none;
		}
		.bodyContent img{
			display:inline;
			height:auto;
		}
	/*
	@tab Body
	@section button style
	@tip Set the styling for your email's button. Choose a style that draws attention.
	*/
		#appButton{
			/*@tab Body
@section button style
@tip Set the styling for your email's button. Choose a style that draws attention.*/-moz-border-radius:5px;
			-webkit-border-radius:5px;
			/*@editable*/background-color:#EA5D41;
			border-radius:5px;
		}
	/*
	@tab Body
	@section button style
	@tip Set the styling for your email's button. Choose a style that draws attention.
	*/
		#appButtonContent,#appButtonContent a:link,#appButtonContent a:visited{
			/*@editable*/color:#FFFFFF;
			/*@editable*/font-family:Helvetica;
			/*@editable*/font-size:20px;
			/*@editable*/font-weight:bold;
			line-height:150%;
			text-align:center;
			text-decoration:none;
		}
	/*
	@tab Columns
	@section left column text
	@tip Set the styling for your email's left column text. Choose a size and color that is easy to read.
	*/
		.leftColumnContent{
			/*@editable*/color:#505050;
			/*@editable*/font-family:Helvetica;
			/*@editable*/font-size:13px;
			/*@editable*/line-height:150%;
			/*@editable*/text-align:left;
		}
	/*
	@tab Columns
	@section left column link
	@tip Set the styling for your email's left column links. Choose a color that helps them stand out from your text.
	*/
		.leftColumnContent a:link,.leftColumnContent a:visited,.leftColumnContent a .yshortcuts {
			/*@editable*/color:#EA5D41;
			/*@editable*/font-weight:normal;
			/*@editable*/text-decoration:none;
		}
	/*
	@tab Columns
	@section right column text
	@tip Set the styling for your email's right column text. Choose a size and color that is easy to read.
	*/
		.rightColumnContent{
			/*@editable*/color:#505050;
			/*@editable*/font-family:Helvetica;
			/*@editable*/font-size:13px;
			/*@editable*/line-height:150%;
			/*@editable*/text-align:left;
		}
	/*
	@tab Columns
	@section right column link
	@tip Set the styling for your email's right column links. Choose a color that helps them stand out from your text.
	*/
		.rightColumnContent a:link,.rightColumnContent a:visited,.rightColumnContent a .yshortcuts {
			/*@editable*/color:#EA5D41;
			/*@editable*/font-weight:normal;
			/*@editable*/text-decoration:none;
		}
		.rightColumnContent img,.leftColumnContent img,.centerColumnContent img{
			display:inline;
			height:auto;
		}
	/*
	@tab Footer
	@section footer style
	@tip Set the  top border for your email's footer area.
	@theme footer
	*/
		#templateFooter{
			/*@editable*/border-top:1px solid #CCCCCC;
		}
	/*
	@tab Footer
	@section footer text
	@tip Set the styling for your email's footer text. Choose a size and color that is easy to read.
	@theme footer
	*/
		.footerContent{
			/*@editable*/color:#707070;
			/*@editable*/font-family:Helvetica;
			/*@editable*/font-size:11px;
			/*@editable*/line-height:125%;
			/*@editable*/text-align:left;
		}
	/*
	@tab Footer
	@section footer link
	@tip Set the styling for your email's footer links. Choose a color that helps them stand out from your text.
	*/
		.footerContent a:link,.footerContent a:visited,.footerContent a .yshortcuts {
			/*@editable*/color:#505050;
			/*@editable*/font-weight:normal;
			/*@editable*/text-decoration:underline;
		}
		.footerContent img{
			display:inline;
		}
		#monkeyRewards img{
			max-width:190px;
		}
</style></head>
    <body leftmargin="0" marginwidth="0" topmargin="0" marginheight="0" offset="0">
    	<center>
        	<table border="0" cellpadding="0" cellspacing="0" height="100%" width="100%" id="backgroundTable">
            	<tr>
                	<td align="center" valign="top">
                        <!-- // Begin Template Preheader \\ -->
                        <table border="0" cellpadding="10" cellspacing="0" width="100%" id="templatePreheader">
                            <tr>
                                <td align="center" valign="top">
                                    <table border="0" cellpadding="0" cellspacing="0" width="600">
                                    	<tr>
                                        	<td valign="top" class="preheaderContent" style="padding-right:20px;" mc:edit="preheader_content">
                                                Use this area to offer a short teaser of your email's content. Text here will show in the preview area of some email clients.
                                            </td>
                                            <!-- *|IFNOT:ARCHIVE_PAGE|* -->
											<td valign="top" width="200" class="preheaderContent" mc:edit="preheader_link">
                                                Is this email not displaying correctly?<br><a href="*|ARCHIVE|*" target="_blank">View it in your browser</a>.
                                            </td>
											<!-- *|END:IF|* -->
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                        </table>
                        <!-- // End Template Preheader \\ -->
                    	<table border="0" cellpadding="0" cellspacing="0" width="600" id="templateContainer">
                        	<tr>
                            	<td align="center" valign="top" style="padding-top:60px;">
                                    <!-- // Begin Template Header \\ -->
                                	<table border="0" cellpadding="0" cellspacing="0" width="600" id="templateHeader">
                                    	<tr>
                                        	<td colspan="3" class="headerContent" style="padding-bottom:40px;" mc:edit="header_content">
                                            	<h1>Keep track of your mailing list V.I.P.s on the go.</h1>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td align="center" valign="top">
                                                <table border="0" cellpadding="0" cellspacing="0">
                                                    <tr>
                                                        <td align="center" height="450" valign="top" width="25">
                                                            <img src="http://gallery.mailchimp.com/27aac8a65e64c994c4416d6b8/images/android_vert_left.png" height="450" width="25" style="display:block !important;">
                                                        </td>
                                                        <td align="center" height="460" valign="top" width="200">
                                                        	<table border="0" cellpadding="0" cellspacing="0">
																<tr>
                                                                	<td align="center" height="50" valign="top" width="200">
                                                                    	<img src="http://gallery.mailchimp.com/27aac8a65e64c994c4416d6b8/images/android_vert_top.png" height="50" width="200" style="display:block !important;">
                                                                    </td>
                                                                </tr>
																<tr>
                                                                	<td align="center" height="300" valign="top" width="200">
			                                                            <img src="http://www.throwback-app.com/images/android_screenshot.jpg" height="300" width="200" style="display:block !important; max-height:300px; max-width:200px;" id="headerImage campaign-icon" mc:label="header_image" mc:edit="header_image">
                                                                    </td>
                                                                </tr>
																<tr>
                                                                	<td align="center" height="100" valign="top" width="200">
			                                                            <img src="http://gallery.mailchimp.com/27aac8a65e64c994c4416d6b8/images/android_vert_bottom.png" height="100" width="200" style="display:block !important;">
                                                                    </td>
                                                                </tr>
                                                            </table>
                                                        </td>
                                                        <td align="center" height="450" valign="top" width="25">
                                                            <img src="http://gallery.mailchimp.com/27aac8a65e64c994c4416d6b8/images/android_vert_right.png" height="450" width="25" style="display:block !important;">
                                                        </td>
                                                    </tr>
                                                </table>
                                            </td>
                                            <td width="40">
                                            	<br>
                                            </td>
                                            <td valign="top" width="325">
                                            	<table border="0" cellpadding="0" cellspacing="0">
                                                    <tr>
                                                        <td valign="top" width="72" style="padding-right:10px;">
                                                            <img src="http://gallery.mailchimp.com/27aac8a65e64c994c4416d6b8/images/icon_goldenmonkeys.png" style="max-width:72px;" id="appIcon" mc:label="icon_image" mc:edit="icon_image">
                                                        </td>
                                                        <td valign="bottom" class="bodyContent" mc:edit="app_detail">
                                                            <h2>Golden Monkeys</h2>
                                                            <h4>By MailChimp</h4>
                                                        </td>
                                                    </tr>
                                                	<tr>
                                                        <td colspan="2" valign="top" style="padding-top:20px;" class="bodyContent" mc:edit="upper_body">
                                                            Every mailing list has some VIPs. <a href="http://mailchimp.com/features/golden-monkeys/" target="_blank">Golden Monkeys</a> helps you keep track of your most important subscribers so you can see how they respond to your campaigns. Golden Monkeys is available for your Android-based phone in the <a href="https://market.android.com/details?id=com.mailchimp.goldenmonkeys" target="_blank">Android Market</a>.
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                    	<td align="left" colspan="2" valign="top" style="padding-top:20px;">
                                                        	<table border="0" cellpadding="0" cellspacing="0">
                                                            	<tr mc:hideable>
                                                                	<td valign="top" style="padding-bottom:20px;">
                                                                        <table border="0" cellpadding="15" cellspacing="0" id="appButton">
                                                                            <tr>
                                                                                <td align="center" valign="middle" id="appButtonContent" style="padding-right:30px; padding-left:30px;" mc:edit="app_button">
                                                                                    <a href="https://market.android.com/details?id=com.mailchimp.goldenmonkeys" target="_blank">Get Golden Monkeys</a>
                                                                                </td>
                                                                            </tr>
                                                                        </table>                                                        
                                                                    </td>
                                                                </tr>
                                                                <tr mc:hideable>
                                                                    <td align="left" valign="middle" mc:edit="app_store_link">
                                                                        <a href="https://market.android.com/details?id=com.mailchimp.goldenmonkeys" target="_blank"><img src="http://gallery.mailchimp.com/27aac8a65e64c994c4416d6b8/images/android_market_logo.png" width="117"></a>
                                                                    </td>
                                                                </tr>
                                                            </table>
                                                        </td>
                                                    </tr>
                                                </table>
                                            </td>
                                        </tr>
                                    </table>
                                    <!-- // End Template Header \\ -->
                                </td>
                            </tr>
                        	<tr>
                            	<td align="center" valign="top" style="padding-top:40px">
                                    <!-- // Begin Template Body \\ -->
                                	<table border="0" cellpadding="0" cellspacing="0" width="600" id="templateBody">
                                    	<tr mc:repeatable>
                                        	<td valign="top" style="padding-top:40px">
                                                <table border="0" cellpadding="0" cellspacing="0" width="100%">
                                                    <tr>
                                                        <td valign="top" width="280" class="leftColumnContent" mc:edit="left_column_content">
                                                            <h3>Real-time Alerts</h3>
                                                            Don't bother with digging through your reports to find out if special people on your list have seen your email. Golden Monkeys sends you push notifications when they open and click.
                                                            <br>
                                                            <br>
	                                                        <h3>Subscriber Profiles</h3>
															See the activity and member ratings of your most important subscribers, and search for subscribers based on important criteria, like geolocation, engagement and purchase activity.
                                                        </td>
                                                        <td width="40">
                                                            <br>
                                                        </td>
                                                        <td valign="top" width="280" class="rightColumnContent" mc:edit="right_column_content">
                                                            <br>
                                                            <br>
                                                            <h4>More Features</h4>
                                                            &bull; Receive push notifications about subscriber activity.
                                                            <br>
                                                            &bull; See where your subscribers are located.
                                                            <br>
                                                            &bull; Browse member ratings and recent activity.
                                                            <br>
                                                            &bull; Email subscriber activity to your coworkers.
                                                            <br>
                                                            &bull; Enable passcode protection in case your phone is lost or stolen.
                                                            <br>
                                                            &bull; Search for subscribers by location, engagement and more.
                                                        </td>
                                                    </tr>
                                                </table>
                                            </td>
                                        </tr>
                                        <tr mc:repeatable>
                                        	<td valign="top">
                                            	<table border="0" cellpadding="0" cellspacing="0" width="100%">
                                                	<tr>
                                                    	<td colspan="3" valign="top" style="padding-top:40px; padding-bottom:20px;" class="bodyContent" mc:edit="screenshot_title">
                                                        	<h3>Android Screenshots</h3>
                                                        </td>
                                                    </tr>
                                                	<tr>
                                                    	<td valign="top" width="280">
                                                        	<img src="http://gallery.mailchimp.com/27aac8a65e64c994c4416d6b8/images/280gmscreen1.jpg" style="max-width:280px;" mc:label="image" mc:edit="left_screenshot"> 
                                                        </td>
                                                        <td width="40">
                                                        	<br>
                                                        </td>
                                                        <td valign="top" width="280">
                                                        	<img src="http://gallery.mailchimp.com/27aac8a65e64c994c4416d6b8/images/280gmscreen2.jpg" style="max-width:280px;" mc:label="image" mc:edit="right_screenshot"> 
                                                        </td>
                                                    </tr>
                                                </table>
                                            </td>
                                        </tr>
                                    </table>
                                    <!-- // End Template Body \\ -->
                                </td>
                            </tr>
                        	<tr>
                            	<td align="center" valign="top" style="padding-top:40px;">
                                    <!-- // Begin Template Footer \\ -->
                                	<table border="0" cellpadding="0" cellspacing="0" width="600" id="templateFooter">
                                    	<tr>
                                        	<td valign="top" style="padding-top:40px;">
                                                <table border="0" cellpadding="0" cellspacing="0">
                                                    <tr>
                                                        <td colspan="2" valign="middle" class="footerContent" style="padding-bottom:20px;" mc:edit="social">
                                                            <a href="*|TWITTER:PROFILEURL|*">follow on Twitter</a> | <a href="*|FACEBOOK:PROFILEURL|*">friend on Facebook</a> | <a href="*|FORWARD|*">forward to a friend</a>&nbsp;
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td valign="top" class="footerContent" style="padding-right:20px;" mc:edit="footer">
                                                            <em>Copyright &copy; *|CURRENT_YEAR|* *|LIST:COMPANY|*, All rights reserved.</em>
                                                            <br>
                                                            *|IFNOT:ARCHIVE_PAGE|* *|LIST:DESCRIPTION|*
                                                            <br>
                                                            <br>
                                                            <strong>Our mailing address is:</strong>
                                                            <br>
                                                            *|HTML:LIST_ADDRESS_HTML|**|END:IF|* 
                                                        </td>
                                                        <td valign="top" width="200" id="monkeyRewards" class="footerContent" mc:edit="monkeyrewards">
                                                            *|IF:REWARDS|* *|HTML:REWARDS|* *|END:IF|*
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td colspan="2" valign="middle" class="footerContent" style="padding-top:20px;" mc:edit="utility">
                                                            <a href="*|UNSUB|*">unsubscribe from this list</a> | <a href="*|UPDATE_PROFILE|*">update subscription preferences</a>&nbsp;
                                                        </td>
                                                    </tr>
                                                </table>
                                            </td>
                                        </tr>
                                    </table>
                                    <!-- // End Template Footer \\ -->
                                </td>
                            </tr>
                        </table>
                        <br>
                        <br>
                        <br>
                    </td>
                </tr>
            </table>
        </center>
    </body>
</html>") 
  	
  	  end
  	  
  	   	  
  	  
  
 


    
  
end
    
class Capsule

  include DataMapper::Resource

  property :id,         Serial    
  property :image_token,String
  property :dueDate, 	DateTime 
  property :caption,	Text, :lazy => false
  property :path,       String 
  property :created_at, DateTime
  property :sent,		Boolean, :default => false	
  property :viewed,		Boolean, :default => false	
  belongs_to :user
  has n, :taggings
  has n, :tagged_users, 'User', :through => :taggings, :via => :user  
 
 	def self.send_due_capsules_to_tagged_users!
  	# get all due_capsules, even if they've been sent to their owners
  		due_capsules = self.due_capsules_for_tagged_users
  	# for each due_capsule
  	  		due_capsules.each do |due_capsule| 
  	# get the image path
  					
  	  				image_path = due_capsule.image_token
  	  				owner = due_capsule.user
  	  				  	#go through each one and send it to the user
  					due_capsule.taggings.each do |tag|
  						# tell the capsule to send
  						
  						EmailSender.send(:address => tag.user.email, :subject => "Here's your Throwback!", :body => "You've received a Throwback from #{owner.email}. Click the link below to view your photo.
  						
  http://throwback-app.com/capsules/" + image_path)
  						# set the tag flag to true
  						tag.sent = true
  						tag.save
  					end
  			end
  	end  	

 
  def self.send_due_capsules!
  	# get all due_capsules
  		due_capsules = self.due_capsules
  	# for each due_capsule
  	  		due_capsules.each do |due_capsule| 
  	# tell the capsule to send
  			due_capsule.send!
  	# set the sent property to true
  	#	due_capsule.update(:sent => true)  
  	  		due_capsule.sent = true
  	# and save the capsule 		
  			due_capsule.save
  		end  
  	end
  	
     
   def generate_image_token
  	Digest::MD5.hexdigest(self.id.to_s + Time.now.to_s + rand(10000).to_s)
  end

  
  def self.due_capsules
  	# get all the capsules whose dueDate is less than the current DateTime
	Capsule.all(:dueDate.lt=> Time.now, :sent => false)
  	# and whose sent flag is not true
  end
  
  def self.due_capsules_for_tagged_users
  	# get all the capsules whose dueDate is less than the current DateTime
	caps = Capsule.all(:dueDate.lt=> Time.now)   	# and whose sent flag is not true
	unsent_caps = caps.find_all { |capsule| capsule.taggings.all(:sent => false).size > 0}
	unsent_caps
   end
  
     
     
  
  def formatted_created_at
  	self.created_at.strftime("%B %d, %Y at %I:%M%p")
  end
  
  def string_to_date
 	 strptime(self, fmt=' %a %B %d %Y %H:%M:%S %z')
  end
  
  
  def path_string
  #"foo.jpg" "foo.tiff"
  	extension="jpg"
  	#extension = filename.split(".").last
  	"capsule_#{self.image_token}.#{extension}"
  end
  
  def image_url
  	 AWS::S3::Base.establish_connection!(:access_key_id => "AKIAI7S3OIOUYPQPFDAA", :secret_access_key => "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")
  	 bucket = AWS::S3::Bucket.find 'hindsight-itp'
  	 bucket[self.path].url
  	   end
  
  def send!  
  	EmailSender.send(:address => self.user.email, :subject => "Here's your Throwback!", :body => "Thanks for being an early user of Throwback, the app that lets you send memories to your future self. A Throwback you took on " + self.formatted_created_at + " is ready for you! Click the link below to view your photo.
  	
http://throwback-app.com/capsules/#{self.image_token}

Love,
Team Throwback"

)
  end
  
   def send_to_tagged_user!  
  	EmailSender.send(:address => self.email, :subject => "Here's your Throwback!", :body => "You've received a Throwback from http://throwback-app.com/capsules/#{self.image_token}")
  end
  
  
end

class Tagging

  include DataMapper::Resource
 # property :id,         Serial  
  property :token, 		String  
  property :confirmed, 	Boolean, :default => false
  property :sent,		Boolean, :default => false	
  
  belongs_to :capsule, :key => true
  belongs_to :user, :key => true
  
  def generate_tag_token
  	Digest::MD5.hexdigest((Time.now.to_s + rand(10000).to_s))
  end
  
  def send_new_user_tag_request!
    owner = self.capsule.user.email
	EmailSender.send(:address => self.user.email, :subject => "Join Throwback today!", :body => "You've been tagged in a Throwback from " + owner + ".

Before you can start to receive Throwbacks, you need to make an account. Please visit the link below to set up an account so you can receive a copy of " + owner + "'s Throwback
  		
http://throwback-app.com/tag/new_user/#{self.token}
  		  		
  		")
  end
  
   def send_tag_request!  
    owner = self.capsule.user.email
  	EmailSender.send(:address => self.user.email, :subject => "Request for tag", :body => "You've been tagged in a Throwback from " + owner + ".
  		
Let us know if you want a copy of your capsule sent to you in the future by clicking the link below:
  		
http://throwback-app.com/tag/#{self.token}
  		  		
  		")
  end


  
end
 
 DataMapper.finalize()
