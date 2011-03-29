require 'thinking_sphinx/deploy/capistrano'

set :application, "Ourvoyce"
set :repository,  "git@github.com:jdagger/ourvoyce.git"

set :scm, :git
set :scm_verbose, "true"
#set :deploy_via, :remote_cache

ssh_options[:forward_agent] = true

set :deploy_to, "/webapps/ourvoyce"

set :use_sudo, false

set :user, :root


role :web, "50.56.91.61", "50.56.91.89"                          # Your HTTP server, Apache/etc
role :app, "50.56.91.61"                          # This may be the same as your `Web` server
role :db,  "50.56.91.61", :primary => true # This is where Rails migrations will run

namespace :deploy do
  desc "Stopping server"
  task :stop do
    find_and_execute_task("unicorn:stop")
    find_and_execute_task("thinking_sphinx:stop")
  end

  desc "Starting server"
  task :start do
    find_and_execute_task("unicorn:start")
    find_and_execute_task("thinking_sphinx:rebuild")
  end

  desc "Restarting server"
  task :restart do
    find_and_execute_task("unicorn:restart")
    find_and_execute_task("thinking_sphinx:rebuild")
  end

end


namespace :unicorn do 
  desc "Start Unicorn on the app server."
  task :start do
    run "/etc/init.d/unicorn start"
  end

  desc "Restart the Unicorn processes on the app server by starting and stopping the cluster."
  task :restart do
    #run "/etc/init.d/unicorn restart"
    run "killall unicorn"
    run "/etc/init.d/unicorn start"
  end

  desc "Stop the Unicorn processes on the app server."
  task :stop do
    #run "/etc/init.d/unicorn stop"
    run "killall unicorn"
  end

  desc "Stop the Unicorn processes on the app server."
  task :reload do
    #run "/etc/init.d/unicorn stop"
    run "killall unicorn"
  end

  #%w(start stop restart reload).each do |action|
    #desc "#{action} the Unicorn processes on the web server."
    ##task action.to_sym , :roles => :web do
      #run "/etc/init.d/unicorn #{action}"
    #end
  #end

end

after "deploy:setup", "thinking_sphinx:shared_sphinx_folder"
