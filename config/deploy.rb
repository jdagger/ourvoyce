set :application, "Ourvoyce"
set :repository,  "git://github.com/jdagger/ourvoyce.git"

set :scm, :git
#set :scm_passphrase, Proc.new { Capistrano::CLI.password_prompt("GIT Password for #{scm_user}:") }  #This is your custom users password
#set :scm_passphrase, "VX8dFZH2"  #This is your custom users password
set :deploy_via, :remote_cache

ssh_options[:forward_agent] = true

set :deploy_to, "/webapps/ourvoyce"

set :use_sudo, false

set :user, :root


role :web, "50.56.91.61"                          # Your HTTP server, Apache/etc
role :app, "50.56.91.61"                          # This may be the same as your `Web` server
role :db,  "50.56.91.61", :primary => true # This is where Rails migrations will run

#set :server_type, :thin

#role :db,  "your slave db-server here"

# If you are using Passenger mod_rails uncomment this:
# if you're still using the script/reapear helper you will need
# these http://github.com/rails/irs_process_scripts

# namespace :deploy do
#   task :start do ; end
#   task :stop do ; end
#   task :restart, :roles => :app, :except => { :no_release => true } do
#     run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
#   end
# end
#
#

namespace :deploy do
  desc "Stopping thin"
  run "service thin stop"

  desc "Stopping nginx"
  run "/etc/init.d/nginx stop"

  desc "Start nginx"
  run "/etc/init.d/nginx/start"

  desc "Start thin"
  run "service thin start"

  #%w(start stop restart).each do |action| 
     #desc "#{action} the Thin processes"  
     #task action.to_sym do
       #find_and_execute_task("thin:#{action}")
    #end
  #end 
end


#namespace :nginx do 
  desc "Start Nginx on the app server."
  task :start do
    run "/etc/init.d/nginx start"
  end

  desc "Restart the Nginx processes on the app server by starting and stopping the cluster."
  task :restart do
    run "/etc/init.d/nginx restart"
  end

  desc "Stop the Nginx processes on the app server."
  task :stop do
    run "/etc/init.d/nginx stop"
  end
  
  desc "Stop the Nginx processes on the app server."
  task :reload do
    run "/etc/init.d/nginx stop"
  end

  %w(start stop restart reload).each do |action|
    desc "#{action} the Nginx processes on the web server."
    task action.to_sym , :roles => :web do
      run "/etc/init.d/nginx #{action}"
    end
  end
  
end

namespace :thin do

  desc "Restarting thin"
  run "service thin restart"
  
  #%w(start stop restart).each do |action|
  #desc "#{action} this app's Thin Cluster"
    #task action.to_sym, :roles => :app do
      #run "service thin #{action}"
    #end
  #end
  
end

