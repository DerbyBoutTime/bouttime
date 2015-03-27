lock '~> 3.3'
set :application, 'bouttime'
set :repo_url, 'git@github.com:WFTDA/bouttime.git'
# Default branch is :master
set :branch, ENV["CAP_BRANCH"] || :master
# Default deploy_to directory is /var/www/my_app
set :deploy_to, "~/applications/#{fetch(:application)}"
# Default value for :scm is :git
# set :scm, :git
# Default value for :format is :pretty
# set :format, :pretty
# Default value for :log_level is :debug
# set :log_level, :debug
# Default value for :pty is false
# set :pty, true
# Default value for :linked_files is []
set :linked_files, %w{.env}
# Default value for linked_dirs is []
set :linked_dirs, %w{bin log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system}
# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }
# Default value for keep_releases is 5
set :keep_releases, 1
set :puma_pid, "tmp/pids/puma.pid"
set :puma_state, "tmp/pids/puma.state"
namespace :deploy do
  desc 'Restart application'
  task :restart do
    invoke "foreman:restart" if fetch(:foreman_restart_required)
    invoke "nginx:restart" if fetch(:nginx_restart_required)
  end
  before :publishing, "foreman:export"
  before :publishing, "nginx:export"
  before :publishing, "puma:copy"
  after :publishing, :restart
  after :restart, :clear_cache do
    on roles(:app), in: :parallel do
      within current_path do
        host.properties.processes.each do |process|
          next if fetch(:foreman_restart_required)
          if process == "web" && test("[ -f #{shared_path.join(fetch(:puma_pid))} ]") && test("kill -0 $( cat #{shared_path.join(fetch(:puma_pid))} )")
            execute :bundle, "exec", "pumactl", "-S", shared_path.join(fetch(:puma_state)), "phased-restart"
          else
            execute :sudo, "restart #{host.user}/#{fetch(:application)}-#{process}"
          end
        end
      end
    end
  end
end
