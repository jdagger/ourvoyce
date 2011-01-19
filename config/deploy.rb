set :user, 'rcalvert'
set :domain, 'snowman.dreamhost.com'
#set :project, 'myapp_name_from_repository'
set :application, "directeddata.com"
set :applicationdir, "/home/#{user}/#{application}"

set :scm, :subversion
set :scm_username, 'deploy'
set :scm_password, 'D3ploY'
set :repository,  "https://venture1.projectlocker.com/EfficiencyLab/svn/Applications/ourvoYce/Application/trunk/SourceCode/Production/"


role :web, domain                          # Your HTTP server, Apache/etc
role :app, domain                          # This may be the same as your `Web` server
role :db,  domain, :primary => true # This is where Rails migrations will run
#role :db,  "your slave db-server here"

set :deploy_to, applicationdir
set :deploy_via, :export

default_run_options[:pty] = true
set :chmod755, "app config db lib public vendor script script/* public/disp*"
set :use_sudo, false


# If you are using Passenger mod_rails uncomment this:
# if you're still using the script/reapear helper you will need
# these http://github.com/rails/irs_process_scripts


 #namespace :deploy do
   #task :start do ; end
   #task :stop do ; end
   #task :restart, :roles => :app, :except => { :no_release => true } do
     #run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
   #end
 #end
