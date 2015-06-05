require './email_sender'
require './models'

desc "This task is called by the Heroku cron add-on"
task :cron do
  Capsule.send_due_capsules_to_tagged_users!
  Capsule.send_due_capsules!
  end
