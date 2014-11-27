namespace :puma do
  desc "Copy puma.rb.environment"
  task :copy do
    on roles(:web) do
      execute(:cp, release_path.join("config/puma.rb.#{fetch(:stage)}"), release_path.join("config/puma.rb"))
    end
  end
end
