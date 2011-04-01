worker_processes 2
working_directory "/webapps/ourvoyce/current"
shared_path "/webapps/ourvoyce/shared"

listen 8080

timeout 30

pid "#{shared_path}/pids/unicorn.pid"
stderr_path "#{shared_path}/log/unicorn.stderr.log"
stdout_path "#{shared_path}/log/unicorn.stdout.log"

preload_app true
GC.respond_to?(:copy_on_write_friendly=) and 
  GC.copy_on_write_friendly = true



before_fork do |server, worker|
  defined?(ActiveRecord::Base) and
    ActiveRecord::Base.connection.disconnect!

  old_pid = "#{server.config[:pid]}.oldbin"
  if old_pid != server.pid
    begin
      sig = (worker.nr + 1) >= server.worker_processes ? :QUIT : :TTOU
      Process.kill(sig, File.read(old_pid).to_i)
    rescue Errno::ENOENT, Errno::ESRCH
    end
  end
  sleep 1
end


after_fork do |server, worker|
  #addr = "127.0.0.1:#{9293 + worker.nr}"
  #server.listen(addr, :tries => -1, :delay => 5, :backlog => 128)
  worker.user('www-data', 'www-data') if Process.euid == 0

  defined?(ActiveRecord::Base) and
    ActiveRecord::Base.establish_connection
end

