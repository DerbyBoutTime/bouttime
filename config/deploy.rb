# config valid only for Capistrano 3.1
lock '3.2.1'

set :application, 'bouttime'
set :repo_url, 'git@github.com:WFTDA/bouttime.git'

# Default branch is :master
ask :branch, proc { `git rev-parse --abbrev-ref HEAD`.chomp }.call

# Default deploy_to directory is /var/www/my_app
set :deploy_to, '/home/bouttime/applications/bouttime'

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

set :puma_role, :web

class ForemanRestartRequired < StandardError; end
class NginxRestartRequired < StandardError; end

namespace :deploy do
  desc 'Restart application'
  task :restart do
    invoke "foreman:restart" if fetch(:foreman_restart_required)
    invoke "nginx:restart" if fetch(:nginx_restart_required)
  end

  before :publishing, "foreman:export"
  before :publishing, "nginx:export"

  after :publishing, :restart

  after :restart, :clear_cache do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
    end
  end
end

namespace :nginx do
  desc "Export"
  task :export do
    on roles(:web) do
      begin
        raise NginxRestartRequired unless latest_release = capture(:ls, '-xr', releases_path).split[1]
        latest_release_path = releases_path.join(latest_release)
        execute(:diff, '-Naur', release_path.join('config/nginx.conf'), latest_release_path.join('config/nginx.conf')) rescue raise(NginxRestartRequired)
      rescue NginxRestartRequired
        set(:nginx_restart_required, true)
        execute(:cp, release_path.join("config/nginx.conf"), "/etc/nginx/sites-available/bouttime")
        execute :sudo, "/usr/local/bin/nginx_ensite bouttime"
      end
    end
  end

  desc "Restart"
  task :restart do
    on roles(:web) do
      execute :sudo, "/etc/init.d/nginx reload"
    end
  end
end

namespace :foreman do
  desc "Export"
  task :export do
    on roles(:app) do
      within release_path do
        begin
          raise ForemanRestartRequired unless latest_release = capture(:ls, '-xr', releases_path).split[1]
          latest_release_path = releases_path.join(latest_release)
          execute(:diff, '-Naur', release_path.join('Procfile'), latest_release_path.join('Procfile')) rescue raise(ForemanRestartRequired)
        rescue ForemanRestartRequired
          set(:foreman_restart_required, true)
          execute :bundle, "exec foreman export upstart /etc/init/#{fetch(:application)} -a #{fetch(:application)} -u #{host.user} -l #{shared_path.join('log')}"
        end
      end
    end
  end

  task :restart do
    on roles(:job, :web) do
      host.roles.each do |role|
        next unless [:job, :web].include?(role)

        execute :sudo, "start bouttime/bouttime-#{role} || sudo restart bouttime/bouttime-#{role}"
      end
    end
  end

  task :start do
    on roles(:job, :web) do
      host.roles.each do |role|
        next unless [:job, :web].include?(role)

        execute :sudo, "start bouttime/bouttime-#{role}"
      end
    end
  end

  task :stop do
    on roles(:job, :web) do
      host.roles.each do |role|
        next unless [:job, :web].include?(role)

        execute :sudo, "stop bouttime/bouttime-#{role}"
      end
    end
  end
end
