class ForemanRestartRequired < StandardError; end

namespace :foreman do
  desc "Export"
  task :export do
    on roles(:app) do
      within release_path do
        begin
          raise ForemanRestartRequired unless latest_release = capture(:ls, '-xr', releases_path).split[1]
          latest_release_path = releases_path.join(latest_release)
          execute :bundle, "exec foreman export upstart /etc/init/ -a #{fetch(:application)}/#{fetch(:application)} -u #{host.user} -l #{shared_path.join('log')}"
          execute(:diff, '-Naur', release_path.join('Procfile'), latest_release_path.join('Procfile')) rescue raise(ForemanRestartRequired)
        rescue ForemanRestartRequired
          set(:foreman_restart_required, true)
        end
      end
    end
  end

  task :restart do
    on roles(:app) do
      host.properties.processes.each do |process|
        execute :sudo, "start bouttime/bouttime-#{process} || sudo restart bouttime/bouttime-#{process}"
      end
    end
  end

  task :start do
    on roles(:app) do
      host.properties.processes.each do |process|
        execute :sudo, "start bouttime/bouttime-#{process}"
      end
    end
  end

  task :stop do
    on roles(:app) do
      host.properties.processes.each do |process|
        execute :sudo, "stop bouttime/bouttime-#{process}"
      end
    end
  end
end
