class NginxRestartRequired < StandardError; end
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
        execute(:cp, release_path.join("config/nginx.conf"), "/etc/nginx/sites-available/#{fetch(:application)}")
        execute :sudo, "/usr/local/bin/nginx_ensite #{fetch(:application)}"
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
